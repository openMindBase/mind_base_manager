import codecs
import os, glob
import networkx as nx
from networkx import find_cycle, NetworkXNoCycle

import graph_helper

"""
checks a list of files for the cyclical property, reports if it exists
in: list of all files as lists with name and content of file
out: None
"""  # TODO: test this with cyclical case
def checkCyclicality(nodesAsStrings: list[[str, str]]) -> None:
    if nodesAsStrings is None or nodesAsStrings == []:
        raise Exception("empty list given to checkCyclicality func")

    # naming convention S=(L,R)
    S = nx.DiGraph()
    edgeList = []
    # convert into proper format
    for i in range(len(nodesAsStrings)):
        nodesAsStrings[i][1] = graph_helper.readDependencies(nodesAsStrings[i][1])
        edgeList.extend(graph_helper.convertAdjacencyNodetoEdgeList(nodesAsStrings[i]))
    S.add_edges_from(edgeList)

    try:
        print("cycles found with following path:" + find_cycle(S))
    except NetworkXNoCycle:
        print("no cycles found")
    return


if __name__ == '__main__':
    filesAsStrings: list[[str, str]] = []
    workingDirectoryName = os.getcwd()
    head, tail = workingDirectoryName.split("lib")
    folderPath = os.path.join(head, 'mind_bases\\germany_school_math')

    for filename in glob.glob(os.path.join(folderPath, '*.md')):
        with codecs.open(filename, 'r', 'utf-8') as file:
            fileString = file.read()
            filesAsStrings.append([graph_helper.extractFilenameFromPath(filename), fileString])
    checkCyclicality(filesAsStrings)
