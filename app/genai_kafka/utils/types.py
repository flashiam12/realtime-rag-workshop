from typing import Dict, List
import ast

class TopicBase(object):
    def __init__(self, id:str) -> None:
        self.id = id
    @staticmethod
    def dict_to_object_generator(obj:Dict, ctx):
        return 

class ContextRaw(TopicBase):
    def __init__(self, id:str, title:str, description:str, content:str, source:str, published_at:str ):
        self.title = title
        self.description = description
        self.content = content
        self.source = source 
        self.published_at = published_at
        super().__init__(id)

    @staticmethod
    def dict_to_object_generator(obj:Dict, ctx):
        if obj is None:
            return None
        return ContextRaw(
                        id=obj.get("id"),
                        title=obj.get("title"),
                        description=obj.get("description"),
                        content=obj.get("content"),
                        source=obj.get("source"),
                        published_at=obj.get("published_at")
                        )

    
class ContextEmbedding(TopicBase):
    def __init__(self, id:str, source:str, knowledge_embedding:List[float], published_at:str) -> None:
        self.source = source
        self.knowledge_embedding = knowledge_embedding
        self.published_at = published_at
        super().__init__(id)

    @staticmethod
    def dict_to_object_generator(obj:Dict, ctx):
        if obj is None:
            return None
        return ContextEmbedding(
                        id=obj.get("id"),
                        source=obj.get("source"),
                        knowledge_embedding=obj.get("knowledge_embedding"),
                        published_at=obj.get("published_at"),
                        )

class PromptRaw(TopicBase):
    def __init__(self, id:str, prompt:str, timestamp: str) -> None:
        self.prompt = prompt
        self.timestamp = timestamp
        super().__init__(id)
    
    @staticmethod
    def dict_to_object_generator(obj:Dict, ctx):
        if obj is None:
            return None
        return PromptRaw(
                        id=obj.get("id"),
                        prompt=obj.get("prompt"),
                        timestamp=obj.get("timestamp")
                        )

class PromptEmbedding(TopicBase):
    def __init__(self, id:str, prompt:str, timestamp: str,embedding_vector:List[float]) -> None:
        self.prompt = prompt
        self.timestamp = timestamp
        self.embedding_vector = embedding_vector
        super().__init__(id)
    
    @staticmethod
    def dict_to_object_generator(obj:Dict, ctx):
        if obj is None:
            return None
        return PromptEmbedding(
                        id=obj.get("id"),
                        prompt=obj.get("prompt"),
                        embedding_vector=obj.get("embedding_vector"),
                        timestamp=obj.get("timestamp")
                        )
    
class PromptContextIndex(TopicBase):
    def __init__(self, id:str, prompt:str, context_indexes:List[str], timestamp: str) -> None:
        self.prompt = prompt
        self.context_indexes = context_indexes
        self.timestamp = timestamp
        super().__init__(id)

    
class PromptEnriched(TopicBase):
    def __init__(self, id:str, messages: str, model: str, temperature: float) -> None:
        self.messages = messages
        self.model = model
        self.temperature = temperature
        super().__init__(id)


def object_to_dict(obj:object, ctx):
    return obj.__dict__




