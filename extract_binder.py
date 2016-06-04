#!/usr/bin/env python
# coding: utf-8
#
# extract all TRANSACTION_* fields from specific DEX/ODEX/OAT files


from __future__ import print_function
import argparse
import subprocess
import cStringIO


FIELD_BEGIN = 'Name: '
FIELD_END = ' type:'
CLASS_BEGIN = ' '
CLASS_END = '\t\tFile: '


def extract_to(file, result):
    output = subprocess.check_output(['dextra', '-f', file])
    lines = output.split('\n')
    clazz = None
    for line in lines:
        # try match field first
        beg = line.find(FIELD_BEGIN)
        end = line.rfind(FIELD_END)
        field = None
        if beg >= 0 and end >= 0:
            field = line[beg+len(FIELD_BEGIN) : end]
            if field.startswith('TRANSACTION_'):
                result[clazz].append(field)
            continue

        # try match class
        line = line.strip()
        if not line.startswith('Class '):
            continue
        end = line.rfind(CLASS_END)
        if end < 0:
            end = len(line)

        beg = line.rfind(CLASS_BEGIN, 0, end)
        clazz = line[beg+len(CLASS_BEGIN) : end]
        if clazz not in result:
            result[clazz] = []


def main():
    parser = argparse.ArgumentParser(
            description='extract all TRANSACTION_* fields from specific DEX/ODEX/OAT files')
    parser.add_argument('-i', nargs='+', dest='input', required=True,
            help='input files')
    parser.add_argument('-o', action='store', dest='output', required=True,
            help='output file')

    args = parser.parse_args()
    result = {}
    for file in args.input:
        extract_to(file, result)

    items = result.items()
    items.sort()

    buf = cStringIO.StringIO()
    try:
        for clazz, fields in items:
            if not fields:
                continue
            buf.write('%s\n' % clazz)
            for field in fields:
                buf.write('\t%s\n' % field)

        with open(args.output, 'w') as output:
            output.write(buf.getvalue())
    finally:
        buf.close()
    


if __name__ == '__main__':
    main()

