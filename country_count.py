from mrjob.job import MRJob
import re

# Untuk mengambil pattern word dari input file
WORD_RE = re.compile(r"[\w']+")


class MRWordFreqCount(MRJob):

    def mapper(self, _, line):
        # WORD_RE.findall(line) output akan berbentuk list
        for word in WORD_RE.findall(line):
            yield (word.lower(), 1)
            # mapper akan menjadi fungsi iterator ((brazil, 1), (indonesia, 1), (spain, 1))

    # combine output dari mapper
    def combiner(self, word, counts):
        yield (word, sum(counts))

    # reduce output dari combiner
    def reducer(self, word, counts):
        yield (word, sum(counts))


if __name__ == '__main__':
    # running class MRWordFreqCount
    MRWordFreqCount.run()
