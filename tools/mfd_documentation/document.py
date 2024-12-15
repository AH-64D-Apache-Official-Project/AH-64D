"""Generate documentation for MFD indices"""
import re
import sys
from xml.etree import ElementTree as ET
import os.path
import os
import argparse

def log_error(msg):
    print(msg, file=sys.stderr)

def split_name(name):
    """Split an index name into its components"""
    return name.split('_')

def join_name(name):
    """Re-join split components"""
    return '_'.join(name)


class PageDef:
    """A page definition, containing sub-pages & mfd indices"""
    def __init__(self, name, sub_pages=None):
        self.name = name
        self.sub_pages = [] if sub_pages is None else sub_pages
        self.float_sources = {}
        self.string_sources = {}

    def add_index(self, index_type, index_name, index_key):
        """Add an MFD index to this page definition, adding to sub-page if applicable"""
        sources = None
        if index_type == 'float':
            sources = self.float_sources
        elif index_type == 'string':
            sources = self.string_sources

        if len(index_name) == 0:
            return
        for sub_page in self.sub_pages:
            if sub_page.name == index_name[0]:
                sub_page.add_index(index_type, index_name[1:], index_key)
                return
        if index_key in sources:
            log_error(f"Collision on key {index_key}: {join_name(index_name)}")
        sources[index_key] = join_name(index_name)

def read_mfd_indices(index_type, match, page_def, input_str):
    """Read MFD indices from a header file and enter them into a page definition"""
    for match in re.finditer(match, input_str, re.MULTILINE):
        page_def.add_index(index_type, split_name(match.group(1)), int(match.group(2)))

def init_page_defs():
    """Initial page definitions (no MFD indices)"""
    return PageDef("MPD Pages",
        [ PageDef("FLT")
        , PageDef("FUEL")
        , PageDef("ENG")
        , PageDef("WPN",
            [ PageDef("GUN")
            , PageDef("RKT")
            , PageDef("MSL")
            ])
        , PageDef("TSD",
            [ PageDef("ROOT")
            , PageDef("SHOW")
            , PageDef("WPT")
            , PageDef("RTE")
            , PageDef("THRT")
            ])
        , PageDef("FCR")
        , PageDef("ASE")
        , PageDef("FREQ")
        , PageDef("CODE")
        , PageDef("CHAN")
        , PageDef("PERF")
        , PageDef("DTU")
        , PageDef("ACUTIL")
        , PageDef("ABR")
        ])

def check_nested_identifiers(page_def):
    """Check that for any ID there is only one value in each branch"""
    def ensure_no_subbranches(page,id):
        if id in page.mfd_indices:
            log_error(f"Collision on ID {id}: {page.mfd_indices[id]}")
        for sub_page in page.sub_pages:
            ensure_no_subbranches(sub_page, id)

    for id in page_def.mfd_indices.keys():
        for sub_page in page_def.sub_pages:
            ensure_no_subbranches(sub_page, id)
    for sub_page in page_def.sub_pages:
        check_nested_identifiers(sub_page)

def export_table_defs(page_def, index_keys):
    """Export a page def into a table"""
    def num_cols(page):
        return max(sum(map(num_cols, page.sub_pages)),1)

    def defs_depth(page):
        return 1 + max(map(defs_depth, page.sub_pages),default=0)

    def render_header(row_num):
        row = ET.Element("tr")
        first_col = ET.Element("th", attrib={'colspan': str(2)})
        if row_num == 0:
            first_col.text = "#"
        row.append(first_col)

        def render_cell(page,current_depth):
            if current_depth >= row_num:
                cell = ET.Element("th", attrib={'colspan': str(num_cols(page))})
                cell.text = page.name
                row.append(cell)
            elif len(page.sub_pages) == 0:
                cell = ET.Element("th", attrib={'colspan': str(num_cols(page))})
                row.append(cell)
            else:
                for sub_page in page.sub_pages:
                    render_cell(sub_page,current_depth+1)
        render_cell(page_def, 0)
        return row

    def render_row(source_type, get_sources, key):
        row = ET.Element("tr")

        if key == 0:
            type_cell = ET.Element('th', attrib={'rowspan': str(len(index_keys))})
            type_cell.text = source_type
            row.append(type_cell)

        key_cell = ET.Element("th")
        key_cell.text = str(key)
        row.append(key_cell)

        def render_cell(page):
            if key in get_sources(page):
                cell = ET.Element("td", attrib={'colspan': str(num_cols(page))})
                cell.text = get_sources(page)[key]
                row.append(cell)
            elif len(page.sub_pages) == 0:
                cell = ET.Element("td", attrib={'colspan': str(num_cols(page))})
                row.append(cell)
            else:
                for sub_page in page.sub_pages:
                    render_cell(sub_page)
        render_cell(page_def)
        return row

    table_header = ET.Element("thead")
    for i in range(defs_depth(page_def)):
        table_header.append(render_header(i))

    table_body = ET.Element("tbody")
    for key in index_keys:
        table_body.append(render_row('Float', lambda x: x.float_sources, key))
    for key in index_keys:
        table_body.append(render_row('String', lambda x: x.string_sources, key))

    table = ET.Element("table")
    table.append(table_header)
    table.append(table_body)
    return table

def main():
    """Read MFD page defs from header file and output definition"""
    

    parser = argparse.ArgumentParser(description='Generate MFD documentation')
    parser.add_argument('filepath', metavar="input", type=str, nargs='?', help="Path to mfdConstants.h")
    parser.add_argument('--output', dest="output", action="store", nargs='?', help="Output path (by default prints to stdout)")

    args=parser.parse_args()
    run(args)

def run(args):
    with open(os.path.join(os.path.dirname(__file__), 'style.css')) as file:
        css_str = file.read()
    
    if args.filepath is None:
        args.filepath = os.path.join('@AH-64D Apache Longbow', 'Addons', 'fza_ah64_mpd', 'headers', 'mfdConstants.h')

    with open(args.filepath, "r", encoding="utf-8") as file:
        input_str = file.read()

    sources = init_page_defs()
    read_mfd_indices(
        'float', r'^#define\s+MFD_IND_([\w_\d]+)\s+(\d+)', sources, input_str)

    read_mfd_indices(
        'string', r'^#define\s+MFD_TEXT_IND_([\w_\d]+)\s+(\d+)', sources, input_str)

    sources.string_sources = {}
    sources.float_sources = {}

    head = ET.Element("head")

    css = ET.Element('style')
    css.text = css_str
    head.append(css)

    body = ET.Element("body")
    
    mpd_sources_header = ET.Element("h1")
    mpd_sources_header.text = "MPD Sources"
    body.append(mpd_sources_header)
    body.append(export_table_defs(sources, range(20)))

    html = ET.Element("html")
    html.append(head)
    html.append(body)

    if (args.output is None):
        ET.ElementTree(html).write(
            sys.stdout, "unicode", method="html")
    else:
        os.makedirs(os.path.dirname(args.output), exist_ok=True)
        with open(args.output, "x", encoding="utf-8") as file:
            ET.ElementTree(html).write(
                file, "unicode", method="html")


if __name__ == "__main__":
    main()
