import json
import os
from google.cloud import aiplatform

def stream_update_vector_search_index(datapoints) -> None:

  aiplatform.init(project=project_id, location=location)
  # Create the index instance from an existing index with stream_update
  my_index = aiplatform.MatchingEngineIndex(index_name=index_name)
  # Upsert the datapoints to the index
  my_index.upsert_datapoints(datapoints=datapoints)


##############################################################################################
# main

index_name=os.environ.get("INDEX_NAME")
project_id = os.environ.get("PROJECT_ID")
location = os.environ.get("REGION")


def context(request):

  request_json = request.get_json()
  
  context_details = request_json[0]['value']

  knowledge_embedding = context_details['knowledge_embedding']

  datapoint_id = context_details['id']  
  
  try:
    # Update Vector
    datapoints = [
    {"datapoint_id": datapoint_id, "feature_vector": knowledge_embedding}
    ]
    stream_update_vector_search_index(datapoints)
    return 'Datapoint {} published to vector search'.format(datapoint_id)
  except Exception as e:
    return e
  

