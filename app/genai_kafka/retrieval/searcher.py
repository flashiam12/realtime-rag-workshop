from typing import List
from pymongo import MongoClient
from ..retrieval.vars import MONGO_URL, MONGO_USER, MONGO_PASSWORD, MONGO_COLLECTION, MONGO_DATABASE, MONGO_DATABASE_INDEX
import certifi

class IndexSearch():
    def __init__(self) -> None:
        self.client = MongoClient("mongodb+srv://{0}:{1}@{2}/?retryWrites=true&w=majority".format(MONGO_USER, MONGO_PASSWORD, MONGO_URL[len("mongodb+srv://"):]), tlsCAFile=certifi.where())
        self.database = self.client.get_database(MONGO_DATABASE)
        self.collection = self.database.get_collection(MONGO_COLLECTION)
        pass
    def query_indexes(self, prompt_embedding:List[float]):
        result = self.collection.aggregate([
                                {
                                    "$vectorSearch": {
                                    "index": MONGO_DATABASE_INDEX,
                                    "path": "knowledge_embedding",
                                    "queryVector": prompt_embedding,
                                    "numCandidates": 100,
                                    "limit": 10
                                    }
                                },
                                {
                                    "$project": {
                                    "_id": 0,
                                    "knowledge_embedding": 0,
                                    "score": { "$meta": "vectorSearchScore" }
                                    }
                                }])
        return result

