from typing import List
from pymongo import MongoClient
from ..retrieval.vars import LOCATION, PROJECT, INDEX_ENDPOINT, DEPLOYED_INDEX_ID
from google.cloud import aiplatform

class IndexSearch():

    def __init__(
        self
    ):
        self.location = LOCATION
        self.project_id = PROJECT
        self.index_endpoint=INDEX_ENDPOINT
        self.deployed_index_id = DEPLOYED_INDEX_ID
        aiplatform.init(project=self.project_id, location=self.location)
        pass


    def query_indexes(self, prompt_embedding:List[float]):
        my_index_endpoint = aiplatform.MatchingEngineIndexEndpoint(
        index_endpoint_name=self.index_endpoint
        )
        # Query the index endpoint for the nearest 10 neighbors.
        resp = my_index_endpoint.find_neighbors(
            deployed_index_id=self.deployed_index_id,
            queries=[prompt_embedding],
            num_neighbors=10,
            return_full_datapoint=False,
        )
        return resp

