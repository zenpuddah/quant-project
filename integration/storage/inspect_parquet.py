"""Inspect a retained manual fixture; no pandas or project Python binding needed."""

import argparse

import pyarrow.parquet as pq


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("file", help="Parquet file printed by the manual C++ example")
    args = parser.parse_args()
    parquet = pq.ParquetFile(args.file)
    print(f"rows={parquet.metadata.num_rows} row_groups={parquet.metadata.num_row_groups}")
    print("Arrow schema:")
    print(parquet.schema_arrow.remove_metadata())
    print("Dataset metadata:")
    for key, value in sorted((parquet.metadata.metadata or {}).items()):
        if key.startswith(b"quant."):
            print(f"{key.decode()}={value.decode()}")
    print("Physical rows:")
    for row in parquet.read().to_pylist():
        print(row)


if __name__ == "__main__":
    main()
