from openai import OpenAI

client = OpenAI(base_url="http://localhost:8060/v1", api_key="dummy")

resp = client.chat.completions.create(
    model="RedHatAI/Llama-3.3-70B-Instruct-FP8-dynamic",
    messages=[{"role": "user", "content": "Chào mày"}],
    max_tokens=200,
    stream=True,
)

for chunk in resp:
    delta = chunk.choices[0].delta.content
    if delta:
        print(delta, end="", flush=True)
print()
