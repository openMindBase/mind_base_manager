
#in: file
#out: files dependency names list
def readDependencies(nodeAsString: str) -> list[str]:
    returnList = []

    l = nodeAsString.split("##### Tags")
    dependencyString :str= l[0]
    dependencyStringList=dependencyString.splitlines()
    dependencyStringList=dependencyStringList[1:]
    for line in dependencyStringList:
        line=line[2:]
        returnList.append(line[:-2])
    return returnList

#C:\Users\49176\PycharmProjects\mind_base_manager\mind_bases\germany_school_math\Potenzgesetz 5.md
# -> Potenzgesetz 5
def extractFilenameFromPath(path)->str:
    name=path.split("\\")
    name=name[-1]
    return name[:-3]

#in: adjacency list: [["name1",["nextNode1","nextNode2"]],...,["name2",["nextNode3"]]]
#out: [("name1","nextNode1"),...,("name2","nextNode3")]
def convertAdjacencyListToEdgeList(adjacencyGraphList :[[str,[str]]])->[(str,str)]:
    edgeList=[]
    for node in adjacencyGraphList:
        edgeList.extend(convertAdjacencyNodetoEdgeList(node))
    return edgeList

def convertAdjacencyNodetoEdgeList(node :[str,[str]]) -> [(str,str)]:
    edgeList=[]
    for successorNode in node[1]:
        edgeList.append((node[0], successorNode))
    return edgeList