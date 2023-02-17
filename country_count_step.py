from mrjob.job import MRJob
from mrjob.step import MRStep
import re

WORD_RE = re.compile(r"[\w']+")


class MRWordFreqCount(MRJob):
    def steps(self):
        return [
            MRStep(
                mapper=self.mapper_country,
                reducer=self.reducer_country
            )
        ]

    def mapper_country(self, _, line):
        # WORD_RE.findall(line) output akan berbentuk list
        for word in WORD_RE.findall(line):
            yield (word.lower(), 1)

    def reducer_country(self, word, counts):
        yield (word, sum(counts))

if __name__ == '__main__':
    MRWordFreqCount.run()
