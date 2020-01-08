import pandas as pd
import sys


def Dupplicate_count_column(dataf, ID_column, dup_column):
    dataf = dataf[dataf.name.str.contains("/2") == False]
    dupplicate_serie = dataf.groupby(dataf[ID_column], as_index=False).size()
    dupplicate_quants = list(dupplicate_serie.values)
    unique_keys = list(dupplicate_serie.keys())
    dataf_dup = pd.DataFrame(
        data={
            ID_column: unique_keys,
            dup_column: dupplicate_quants
        }
    )
    dataf = pd.merge(dataf, dataf_dup, on=ID_column, how='left')
    dataf = dataf.drop_duplicates(subset=['chr', 'strand', 'start', 'end'])
    return dataf


def main(bedpath, output):
    bed_df = pd.read_csv(
        filepath_or_buffer=bedpath,
        index_col=False,
        sep='\t',
        header=None,
        names=['chr', 'start', 'end', 'name', 'score', 'strand']
    )
    ID_column = 'ID'
    dup_column = 'quantity'
    for col in ['chr', 'start', 'end', 'strand']:
        bed_df[col] = bed_df[col].map(str)
    bed_df[ID_column] = bed_df[['chr', 'start', 'end', 'strand']].apply(
        lambda x: '_'.join(x),
        axis=1
    )
    print(bed_df)
    bed_df = Dupplicate_count_column(bed_df, ID_column, dup_column)
    bed_df = bed_df.sort_values(['chr', 'strand', 'start', 'end'], axis=0)
    cols = ['chr', 'start', 'end', 'name', dup_column, 'strand']
    bed_df = bed_df[cols]
    bed_df.to_csv(path_or_buf=output, index=False, sep='\t', header=None)


main(snakemake.input.bed, snakemake.output.bed)
