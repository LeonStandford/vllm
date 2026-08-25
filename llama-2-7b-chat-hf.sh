#!/bin/bash
export CUDA_VISIBLE_DEVICES=0

export HF_HOME=/mnt/HDD4/acm_llm_data/huggingface

export LMCACHE_CHUNK_SIZE=256
export LMCACHE_LOCAL_CPU=true
export LMCACHE_MAX_LOCAL_CPU_SIZE=20

cd "$(dirname "$0")" && mkdir -p logs
set -a; source .env; set +a

.venv/bin/python -m vllm.entrypoints.openai.api_server \
  --model meta-llama/Llama-2-7b-chat-hf \
  --max-model-len 4096 \
  --gpu-memory-utilization 0.35 \
  --max-num-seqs 16 \
  --tensor-parallel-size 1 \
  --enable-prefix-caching \
  --kv-transfer-config '{"kv_connector":"LMCacheConnectorV1","kv_role":"kv_both"}' \
  --port 8061 \
  2>&1 | tee logs/llama-2-7b-chat-hf.log
