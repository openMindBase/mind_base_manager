import networkx as nx
from matplotlib import pyplot as plt
from networkx import DiGraph


# converts whole file strings to DiGraph
def convertFilesAsStringToDiGraph(filesAsStrings: list[[str, str]]) -> DiGraph:
    if filesAsStrings is None or filesAsStrings == []:
        raise Exception("empty list given to convertFilesAsStringToDiGraph func")
    G = nx.DiGraph()

    # convert into proper format
    for i in range(len(filesAsStrings)):
        # if 'Nennen - Bedingung für Punktsymmetrie einer ganzrationalen Funktion'==filesAsStrings[i][0]:
        #     filesAsStrings[i][1] = readDependencies(filesAsStrings[i][1])
        #     print(convertAdjacencyNodetoEdgeList(filesAsStrings[i]))
        # else:
            filesAsStrings[i][1] = readDependencies(filesAsStrings[i][1])
            G.add_edges_from(convertAdjacencyNodetoEdgeList(filesAsStrings[i]))
    return G


# returns section string dict
def convertDiGraphToHardDependentsSectionStrings(Graph: DiGraph) -> dict[str:str]:
    header = "##### Hard-Dependents\r\n"
    returnDict = {}

    adjList: dict = Graph.succ
    adjList = adjList.copy()
    while len(adjList) != 0:
        temp = adjList.popitem()
        tempSection = header
        for successorName in temp[1]:
            tempSection += "[[" + successorName + "]]\r\n"
        returnDict[temp[0]] = tempSection
        # +".md"
    return returnDict


# in: file
# out: files dependency names list
def readDependencies(nodeAsString: str) -> list[str]:
    returnList = []

    tempL = nodeAsString.split("##### Tags")
    dependencyString: str = tempL[0]
    print(dependencyString)
    dependencyStringList = dependencyString.splitlines()
    dependencyStringList = dependencyStringList[1:]
    for line in dependencyStringList:
        line1 = line[2:]
        line1 = line1[:-2]
        returnList.append(line1)
    print(returnList)
    return returnList


# C:\Users\49176\PycharmProjects\mind_base_manager\mind_bases\germany_school_math\Potenzgesetz 5.md
# -> Potenzgesetz 5
def extractFilenameFromPath(path) -> str:
    name = path.split("\\")
    name = name[-1]
    return name[:-3]


# in: adjacency list: [["name1",["nextNode1","nextNode2"]],...,["name2",["nextNode3"]]]
# out: [("name1","nextNode1"),...,("name2","nextNode3")]
def convertAdjacencyListToEdgeList(adjacencyGraphList: [[str, [str]]]) -> [(str, str)]:
    edgeList = []
    for node in adjacencyGraphList:
        edgeList.extend(convertAdjacencyNodetoEdgeList(node))
    return edgeList


def convertAdjacencyNodetoEdgeList(node: [str, [str]]) -> [(str, str)]:
    edgeList = []
    for successorNode in node[1]:
        edgeList.append((node[0], successorNode))
    return edgeList
