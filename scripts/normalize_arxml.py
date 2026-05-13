#!/usr/bin/env python3
"""
Normalize ARXML file by sorting all named elements (those with a SHORT-NAME child)
alphabetically. Designed for use before diffing ARXML files.

Usage:
    normalize_arxml.py input.arxml [-o output.arxml]
    normalize_arxml.py input.arxml          # writes input.normalized.arxml
"""

import sys
import argparse

try:
    from lxml import etree
except ImportError:
    sys.exit("lxml is required: pip install lxml")


def local_name(tag):
    """Strip XML namespace from a tag, e.g. '{http://...}SHORT-NAME' -> 'SHORT-NAME'."""
    return tag.split('}', 1)[-1] if '}' in tag else tag


def get_short_name(element):
    """Return the SHORT-NAME text of an element, or None if it has no SHORT-NAME child."""
    for child in element:
        if local_name(child.tag) == 'SHORT-NAME':
            return child.text or ''
    return None


def sort_element(element):
    """
    Recursively sort children that have a SHORT-NAME child, by SHORT-NAME value.
    Children without SHORT-NAME keep their relative order among themselves.
    Tail whitespace stays at each slot position so indentation is preserved.
    """
    for child in list(element):
        sort_element(child)

    children = list(element)
    # Capture the tail text at each child's current position (indentation whitespace).
    tails = [child.tail for child in children]

    named_indices = [i for i, c in enumerate(children) if get_short_name(c) is not None]
    if len(named_indices) < 2:
        return  # nothing to reorder

    sorted_named = sorted(
        [children[i] for i in named_indices],
        key=lambda e: get_short_name(e) or '',
    )

    # Slot the sorted named elements back into their original index positions.
    new_children = list(children)
    for slot, child in zip(named_indices, sorted_named):
        new_children[slot] = child

    # Assign the tail that belongs to each position (not each element).
    for child, tail in zip(new_children, tails):
        child.tail = tail

    for child in children:
        element.remove(child)
    for child in new_children:
        element.append(child)


def normalize(input_path, output_path):
    # remove_blank_text strips pure-whitespace text nodes so pretty_print
    # can re-emit clean, consistent indentation regardless of input style.
    parser = etree.XMLParser(remove_blank_text=True)
    tree = etree.parse(input_path, parser)
    sort_element(tree.getroot())
    tree.write(
        output_path,
        xml_declaration=True,
        encoding='UTF-8',
        pretty_print=True,
    )


def main():
    ap = argparse.ArgumentParser(
        description='Normalize ARXML by sorting SHORT-NAME elements alphabetically.'
    )
    ap.add_argument('input', help='Input ARXML file path')
    ap.add_argument(
        '-o', '--output',
        help='Output file path (default: <input>.normalized.arxml)',
    )
    args = ap.parse_args()

    if args.output:
        output = args.output
    else:
        stem = args.input[:-6] if args.input.endswith('.arxml') else args.input
        output = stem + '.normalized.arxml'

    normalize(args.input, output)
    print(f'{args.input} -> {output}', file=sys.stderr)


if __name__ == '__main__':
    main()
