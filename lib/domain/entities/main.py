from networkx import transitive_reduction, DiGraph
import matplotlib.pyplot as plt
import cyclicality_checker
import transitivity_cleaner
import codecs
import os, glob
from lib.domain.entities import graph_helper
import networkx as nx

from lib.domain.entities.graph_helper import convertFilesAsStringToDiGraph, convertDiGraphToHardDependentsSectionStrings


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
path: path to folder of md
optional: writeDependentsContent: list[[str, str]] is passed if write mode for dependents is to be activated,
then filesAsStrings is passed back as empty list
out: files as String in format list[[str, str]] with header and content
"""


def fileMdReadWriteDependents(path: str, writeDependentsContent=None) -> list[[str, str]]:
    writeDependentsContent: dict[str:str]
    filesAsStrings: list[[str, str]] = []
    writtenToCounter = 0

    for filename in glob.glob(os.path.join(path, '*.md')):
        with codecs.open(filename, 'r', 'utf-8') as file:
            fileString = file.read()
            justFilename = graph_helper.extractFilenameFromPath(filename)

            filesAsStrings.append([justFilename, fileString])

            if writeDependentsContent is not None:
                writeDependentsContent[justFilename]


    print(str(len(filesAsStrings)) + " files extracted")
    if writeDependentsContent is not None:
        print("written to " + str(writtenToCounter) + " files")
        return []
    else:  # read mode
        return filesAsStrings


if __name__ == '__main__':
    #showExampleGraph()
    workingDirectoryName = os.getcwd()
    head, tail = workingDirectoryName.split("lib")
    folderPath = os.path.join(head, 'mind_bases\\test')

    G: DiGraph = convertFilesAsStringToDiGraph(fileMdReadWriteDependents(folderPath))

    # check for graph properties
    cyclicality_checker.checkCyclicality(G)
    cleanedG = transitivity_cleaner.cleanTransitivity(G)
    if G.nodes != cleanedG.nodes:
        print("cleaning of transitive edges occurred\n")
    else:
        print("no cleaning of transitive edges was necessary\n")

    dependencySectionsStrings: dict[str:str] = convertDiGraphToHardDependentsSectionStrings(G)
    fileMdReadWriteDependents(folderPath, dependencySectionsStrings)
