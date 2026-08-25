#!/bin/bash
export CUDA_VISIBLE_DEVICES=1

export HF_HOME=/mnt/HDD4/acm_llm_data/huggingface

export LMCACHE_CHUNK_SIZE=256
export LMCACHE_LOCAL_CPU=true
export LMCACHE_MAX_LOCAL_CPU_SIZE=20 

cd "$(dirname "$0")" && mkdir -p logs
set -a; source .env; set +a

.venv/bin/python -m vllm.entrypoints.openai.api_server \
  --model RedHatAI/Llama-3.3-70B-Instruct-FP8-dynamic \
  --max-model-len 8192 \
  --gpu-memory-utilization 0.88 \
  --max-num-seqs 16 \
  --tensor-parallel-size 1 \
  --enable-prefix-caching \
  --kv-transfer-config '{"kv_connector":"LMCacheConnectorV1","kv_role":"kv_both"}' \
  --port 8060 \
  2>&1 | tee logs/llama-3.3-70b.log
