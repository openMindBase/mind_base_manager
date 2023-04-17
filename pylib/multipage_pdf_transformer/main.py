import pypdfium2 as pdfium

"""
You can use this script to transform a multipage PDF into multiple learning Goals represented as md files.
"""


def write_learning_goal_to_md(path: str, description: str, tag: str, dependents=None, collection_goal=False):
    if dependents is None:
        dependents = []
    file = open(path, "x")

    file.write("##### Hard-Dependents\n")
    for dependent in dependents:
        file.write("[[" + (dependent.split(".")[0]) + "]]\n")
    file.write("##### Tags\n")
    file.write("#" + tag + "\n")
    file.write("##### Metadata\n")
    if collection_goal:
        file.write("isCollectionGoal=true\n")
        file.write("isOrGateway=false\n")
        file.write("shouldTest=false\n")
        file.write("singleExercise=true\n")
    else:
        file.write("isCollectionGoal=false\n")
        file.write("isOrGateway=false\n")
        file.write("shouldTest=true\n")
        file.write("singleExercise=true\n")

    file.write("## Description\n")
    file.write(description + "\n")
    file.close()

    return


def convert_pdf_to_multiple_pngs(pdf_path, img_prefix):
    pdf = pdfium.PdfDocument(pdf_path)

    dependents = []

    # render a single page (in this case: the first one)
    for i in range(len(pdf)):
        page = pdf[i]
        pil_image = page.render(scale=3).to_pil()
        pil_image.save(img_prefix + "_%02d.png" % (i + 1))
        write_learning_goal_to_md(img_prefix + "_%02d.md" % (i + 1),
                                  "![[" + (img_prefix + "_%02d.png" % (i + 1)) + "]]", img_prefix)
        dependents.append(img_prefix + "_%02d.md" % (i + 1))

    write_learning_goal_to_md(img_prefix + ".md", "everything about:" + img_prefix, img_prefix + "\n#root", dependents,
                              True)
    return


def main():
    multi_page_pdf_path = input("Enter path to multipage PDF: ")
    img_prefix = input("Enter image prefix: ")

    # multi_page_pdf_path = input("Enter path to multipage PDF: ")

    convert_pdf_to_multiple_pngs(multi_page_pdf_path, img_prefix)
    # write_learning_goal_to_md("test.md", "test", "test")
    return


if __name__ == '__main__':
    main()
