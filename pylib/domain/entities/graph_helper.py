import networkx as nx
from networkx import DiGraph


# TODO make dict to no be in O(n^2)
# checks for duplicate file names / node names
def checkDuplicates(filesAsStrings: list[[str, str]]) -> None:
    j = 0
    for file in filesAsStrings:
        fileName = file[0]
        j += 1
        for i in range(j, len(filesAsStrings)):
            if fileName == filesAsStrings[i][0]:
                raise Exception("duplicate file(=Node in Graph) detected => invalid Graph")
    return


# converts whole file strings to DiGraph, leaves out orphan nodes (unconnected node)
def convertFilesAsStringToConnectedDiGraph(filesAsStrings: list[[str, str]]) -> DiGraph:
    if filesAsStrings is None or filesAsStrings == []:
        raise Exception("empty list given to convertFilesAsStringToDiGraph func")
    G = nx.DiGraph()

    # convert into proper format
    for i in range(len(filesAsStrings)):
        filesAsStrings[i][1] = readDependencies(filesAsStrings[i][1])
        G.add_edges_from(convertAdjacencyNodeToEdgeList(filesAsStrings[i]))
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
    if len(tempL) != 2:
        raise Exception("incorrect formatting of file, 2 instances of ##### Tags in:" + nodeAsString)
    dependencyString: str = tempL[0]
    dependencyStringList = dependencyString.splitlines()
    if dependencyStringList[0] != "##### Hard-Dependents":
        raise Exception("incorrect formatting of file, doesn't start with ##### Hard-Dependents in:" + nodeAsString)
    dependencyStringList = dependencyStringList[1:]
    for line in dependencyStringList:
        if not line.endswith("]]") or not line.startswith("[["):
            raise Exception("incorrect formatting of file, dependecy not correctly fomatted in:" + nodeAsString)
        line1 = line[2:]
        line1 = line1[:-2]
        returnList.append(line1)
    return returnList


# writes a dependency to a fileAsString
def writeDependencies(dependenciesSection: str, nodeAsString: str) -> list[str]:
    tempL = nodeAsString.split("##### Tags")
    if tempL[0] != dependenciesSection:
        tempL[0] = dependenciesSection
    returnString = tempL[0] + "##### Tags" + tempL[1]
    returnStringList = returnString.splitlines()
    for i in range(len(returnStringList)):
        returnStringList[i] = returnStringList[i] + "\n"
    return returnStringList


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
        edgeList.extend(convertAdjacencyNodeToEdgeList(node))
    return edgeList


def convertAdjacencyNodeToEdgeList(node: [str, [str]]) -> [(str, str)]:
    edgeList = []
    for successorNode in node[1]:
        edgeList.append((node[0], successorNode))
    return edgeList
