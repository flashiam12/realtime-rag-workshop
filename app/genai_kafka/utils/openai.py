import httpx
import json

def embedding(openai_api:str="None", content:str="None"):
    headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer {0}".format(openai_api)
    }
    base_url = "https://api.openai.com/v1/embeddings"
    body = {
        "input": content, 
        "model": "text-embedding-3-small",
        "encoding_format": "float"
    }
    print(content)
    with httpx.Client() as client:
        try:
            response = client.post(base_url, headers=headers, json=body)
            embedding_response = json.loads(response.text)
            # return embedding_response["data"][0]["embedding"]
            return embedding_response.get("data",[])[0].get("embedding",[])
        except:
            return []