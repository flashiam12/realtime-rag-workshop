def schema_reader(schema_json_file:str):
    with open(schema_json_file, 'r') as file:
        json_data = file.read()
    return """{}""".format(json_data)


context_raw_schema_str = schema_reader("app/schemas/ContextRaw-value.json")

context_embedding_schema_str = schema_reader("app/schemas/ContextEmbedding-value.json")

prompt_raw_schema_str = schema_reader("app/schemas/PromptRaw-value.json")

prompt_context_index_schema_str = schema_reader("app/schemas/PromptContextIndex-value.json")

prompt_enriched_schema_str = schema_reader("app/schemas/PromptEnriched-value.json")

prompt_embedding_schema_str = schema_reader("app/schemas/PromptEmbedding-value.json")