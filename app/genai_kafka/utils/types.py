from typing import Dict
import ast

class TopicBase(object):
    def __init__(self, id:str) -> None:
        self.id = id

class ContextRaw(TopicBase):
    def __init__(self, id:str, title:str, description:str, content:str, source:str, published_at:str ):
        self.title = title
        self.description = description
        self.content = content
        self.source = source 
        self.published_at = published_at
        super().__init__(id)

    
class ContextEmbedding(TopicBase):
    def __init__(self, id:str, source:str, knowledge_embedding:str, published_at:str) -> None:
        self.source = source
        self.knowledge_embedding = knowledge_embedding
        self.published_at = published_at
        super().__init__(id)


class PromptRaw(TopicBase):
    def __init__(self, id:str, prompt:str, timestamp: str) -> None:
        self.prompt = prompt
        self.timestamp = timestamp
        super().__init__(id)

    
class PromptContextIndex(TopicBase):
    def __init__(self, id:str, prompt:str, context_indexes:str, timestamp: str) -> None:
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

def dict_to_object_generator(object_class):
    def dict_to_object(dict:Dict, ctx):
        class_instance_str = f'{object_class.__name__}({", ".join(f"{k}={v}" for k, v in dict.items())})'
        return ast.literal_eval(class_instance_str)
    return dict_to_object
