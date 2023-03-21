import graph_helper
from networkx import transitive_reduction, DiGraph

"""
cleans a list of files for the transitivity property
in: DiGraph
"""#TODO: check for transitve graphs
def cleanTransitivity(Graph :DiGraph)->DiGraph:
    print("processed " + str(len(Graph.edges)) + " edges in transitivity cleaner")
    return transitive_reduction(Graph)
