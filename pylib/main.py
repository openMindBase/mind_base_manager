from networkx import transitive_reduction, DiGraph
import matplotlib.pyplot as plt
from pylib.domain.entities import cyclicality_checker, graph_helper, transitivity_cleaner
import codecs
import os, glob
import networkx as nx
from pylib.domain.entities.graph_helper import convertFilesAsStringToConnectedDiGraph, \
    convertDiGraphToHardDependentsSectionStrings, checkDuplicates, extractFilenameFromPath, writeDependencies
from stopwatch import Stopwatch


# example graph for showcase of functionality of networkx lib
def showExampleGraph():
    G = nx.DiGraph()
    E = [(1, 2), (2, 3), (3, 4), (1, 4), (2, 4)]
    G.add_edges_from(ebunch_to_add=E)
    nx.draw(G, with_labels=True, pos=nx.spring_layout(G), node_color='b', edge_color='r')
    plt.show()
    G = transitive_reduction(G)
    nx.draw(G, with_labels=True, pos=nx.spring_layout(G), node_color='r', edge_color='b')
    plt.show()


"""
in:
path: path to folder of mds
writeDependentsContent: dict[str: str] contents is written to all relevant files 
"""


def fileMdWriteDependents(path: str, writeDependentsContent: dict[str:str]) -> None:
    writtenToCounter = 0
    filesAsStringsDict: dict[str:str] = {}

    # read
    for filename in glob.glob(os.path.join(path, '*.md')):
        with codecs.open(filename, "r", 'utf-8') as file:
            fileString = file.read()
            justFilename = extractFilenameFromPath(filename)

            filesAsStringsDict[justFilename] = fileString
    print(str(len(filesAsStringsDict)) + " files extracted")

    # write
    for filename in glob.glob(os.path.join(path, '*.md')):
        with open(filename, "w", encoding='utf-8') as file:
            justFilename = extractFilenameFromPath(filename)
            # orphan test
            try:
                writeDependentsContent[justFilename]
            except KeyError:
                print("'" + justFilename + "'" + " is an orphan node")
                fileAsString = filesAsStringsDict[justFilename]
                fileAsList = fileAsString.splitlines()
                for i in range(len(fileAsList)):
                    fileAsList[i] = fileAsList[i] + "\n"
                file.writelines(fileAsList)
                file.close()
                continue

            writtenToCounter += 1
            newFileStringList = writeDependencies(writeDependentsContent[justFilename],
                                                  filesAsStringsDict[justFilename])
            file.writelines(newFileStringList)
            file.close()

    print("changed " + str(writtenToCounter) + " files")
    return


"""
in:
path: path to folder of md
out: files as String in format list[[str, str]] with header and whole content of file
"""


def fileMdRead(path: str) -> list[[str, str]]:
    filesAsStrings = []

    for filename in glob.glob(os.path.join(path, '*.md')):
        with codecs.open(filename, "r", 'utf-8') as file:
            fileString = file.read()
            justFilename = extractFilenameFromPath(filename)

            filesAsStrings.append([justFilename, fileString])
    print(str(len(filesAsStrings)) + " files extracted")
    return filesAsStrings


if __name__ == '__main__':
    # TODO: make cooler way to specificy target folder
    # folder in which .mds should be processed
    # "germany_school_math"
    folder = "germany_school_math"

    stopwatch = Stopwatch(2)  # Start a stopwatch
    stopwatch.start()  # Start it again
    # extract path
    workingDirectoryName = os.getcwd()
    head, tail = workingDirectoryName.split("pylib")
    folderPath = os.path.join(head, 'mind_bases\\' + folder)

    filesAsStrings = fileMdRead(folderPath)
    checkDuplicates(filesAsStrings)
    G: DiGraph = convertFilesAsStringToConnectedDiGraph(filesAsStrings)

    # check for graph properties
    cyclicality_checker.checkCyclicality(G)
    cleanedG = transitivity_cleaner.cleanTransitivity(G)
    graphChanged: bool = False
    if G.edges != cleanedG.edges:
        print("cleaning of transitive edges occurred:")
        print(str(G.edges) + " => " + str(cleanedG.edges))
        graphChanged = True
    else:
        print("no transitivity found")
    print("############################################\n")

    dependencySectionsStrings: dict[str:str] = convertDiGraphToHardDependentsSectionStrings(cleanedG)
    if graphChanged: fileMdWriteDependents(folderPath, dependencySectionsStrings)

    stopwatch.stop()  # Stop stopwatch, time freezes
    print("time elapsed: " + str(stopwatch))
