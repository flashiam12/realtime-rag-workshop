INSERT INTO PromptContext
SELECT 
    id AS id, 
    CAST(0.5 AS DOUBLE) AS temperature,
    CAST('gpt-3.5-turbo' AS STRING) AS `model`,
    ARRAY[ROW(CAST('user' AS STRING), CAST(CONCAT('Answer the question based on the given information: Q - ', prompt, 'Information - ', CAST(messages AS STRING)) AS STRING))] AS messages 
FROM (
SELECT 
    ARRAY_CONCAT(title, content, description) as messages,
    id,
    prompt
    FROM (
        SELECT 
            p.prompt_key as prompt_key,
            p.id as id,
            p.prompt as prompt,
            ARRAY_AGG(DISTINCT c.description) AS description,
            ARRAY_AGG(DISTINCT c.title) AS title,
            ARRAY_AGG(DISTINCT c.content) AS content
        FROM 
            ContextRaw AS c
        INNER JOIN 
            (
            SELECT 
                key AS prompt_key, 
                id, 
                prompt, 
                context_index 
                FROM PromptContextIndex CROSS JOIN UNNEST(context_indexes) AS context_index
            ) AS p
        ON 
            c.id = p.context_index
        GROUP BY 
            p.prompt_key,
            p.prompt,
            p.id
        )
    GROUP BY 
        prompt_key,
        id,
        prompt,
        title,
        description, 
        content
);