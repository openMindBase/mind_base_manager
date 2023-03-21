import os, glob
import networkx as nx
from matplotlib import pyplot as plt
from networkx import find_cycle, NetworkXNoCycle, DiGraph

import graph_helper

"""
checks a list of files for the cyclical property, reports if it exists
in: DiGraph
out: None
"""  # TODO: test this with cyclical case
def checkCyclicality(Graph :DiGraph) -> None:
    print("processed " + str(len(Graph.edges)) + " edges in cyclicality checker")
    try:
        print("cycles found with following path:" + find_cycle(Graph))
    except NetworkXNoCycle:
        print("no cycles found")
    return
