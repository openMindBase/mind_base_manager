from networkx import find_cycle, NetworkXNoCycle, DiGraph

"""
checks a list of files for the cyclical property, reports if it exists
in: DiGraph
out: None
"""


def checkCyclicality(Graph: DiGraph) -> None:
    print("processed " + str(len(Graph.edges)) + " edges in cyclicality checker")
    try:
        if isinstance(find_cycle(Graph), list):
            raise Exception("cycles found with following path:" + str(find_cycle(Graph)))
    except NetworkXNoCycle:
        print("no cycles found")
    print("############################################")
    return
