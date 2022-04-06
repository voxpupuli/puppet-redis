# @summary Specify the server maxmemory_policy.
# This can be one of:
# * volatile-lru (Evict using approximated LRU, only keys with an expire set)
# * allkeys-lru (Evict any key using approximated LRU)
# * volatile-lfu (Evict using approximated LFU, only keys with an expire set)
# * allkeys-lfu (Evict any key using approximated LFU)
# * volatile-random (Remove a random key having an expire set)
# * allkeys-random (Remove a random key, any key)
# * volatile-ttl (Remove the key with the nearest expire time (minor TTL)
# * noeviction (Don't evict anything, just return an error on write operations)
type Redis::MemoryPolicy = Enum['volatile-lru', 'allkeys-lru', 'volatile-lfu', 'allkeys-lfu', 'volatile-random',
  'allkeys-random', 'volatile-ttl', 'noeviction']
