#!/bin/bash
# modules/gcp-cassandra/scripts/startup.sh

set -e

# Update system
apt-get update
apt-get upgrade -y

# Install dependencies
apt-get install -y openjdk-11-jdk python3 curl gnupg lsb-release

# Add Cassandra repository
echo "deb https://debian.cassandra.apache.org 41x main" | tee -a /etc/apt/sources.list.d/cassandra.list
curl https://downloads.apache.org/cassandra/KEYS | apt-key add -
apt-get update

# Install Cassandra
apt-get install -y cassandra=${cassandra_version}

# Stop Cassandra to configure it
systemctl stop cassandra

# Format and mount data disk
DEVICE_NAME=$(lsblk -o NAME,HCTL | grep "0:0:0:1" | awk '{print $1}')
mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/$DEVICE_NAME
mkdir -p /data/cassandra
mount -o discard,defaults /dev/$DEVICE_NAME /data/cassandra
echo "/dev/$DEVICE_NAME /data/cassandra ext4 discard,defaults 0 2" >> /etc/fstab

# Set directory permissions
mkdir -p /data/cassandra/data
mkdir -p /data/cassandra/commitlog
mkdir -p /data/cassandra/saved_caches
chown -R cassandra:cassandra /data/cassandra

# Get instance metadata
INSTANCE_NAME=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/name" -H "Metadata-Flavor: Google")
NODE_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/node-id" -H "Metadata-Flavor: Google")
INTERNAL_IP=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip" -H "Metadata-Flavor: Google")

# Configure Cassandra
cat > /etc/cassandra/cassandra.yaml << EOF
cluster_name: '${cluster_name}'
num_tokens: 256
hinted_handoff_enabled: true
max_hint_window_in_ms: 10800000
hinted_handoff_throttle_in_kb: 1024
max_hints_delivery_threads: 2
hints_directory: /data/cassandra/hints
hints_flush_period_in_ms: 10000
max_hints_file_size_in_mb: 128
batchlog_replay_throttle_in_kb: 1024
authenticator: AllowAllAuthenticator
authorizer: AllowAllAuthorizer
role_manager: CassandraRoleManager
roles_validity_in_ms: 2000
permissions_validity_in_ms: 2000
credentials_validity_in_ms: 2000
partitioner: org.apache.cassandra.dht.Murmur3Partitioner
data_file_directories:
  - /data/cassandra/data
commitlog_directory: /data/cassandra/commitlog
saved_caches_directory: /data/cassandra/saved_caches
disk_failure_policy: stop
commit_failure_policy: stop
key_cache_size_in_mb:
key_cache_save_period: 14400
row_cache_size_in_mb: 0
row_cache_save_period: 0
counter_cache_size_in_mb:
counter_cache_save_period: 7200
commitlog_sync: periodic
commitlog_sync_period_in_ms: 10000
commitlog_segment_size_in_mb: 32
seed_provider:
  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
    parameters:
      - seeds: "${seed_nodes}"
concurrent_reads: 32
concurrent_writes: 32
concurrent_counter_writes: 32
concurrent_materialized_view_writes: 32
memtable_allocation_type: heap_buffers
index_summary_capacity_in_mb:
index_summary_resize_interval_in_minutes: 60
trickle_fsync: false
trickle_fsync_interval_in_kb: 10240
storage_port: 7000
ssl_storage_port: 7001
listen_address: $INTERNAL_IP
broadcast_address: $INTERNAL_IP
start_native_transport: true
native_transport_port: 9042
rpc_address: $INTERNAL_IP
broadcast_rpc_address: $INTERNAL_IP
start_rpc: false
rpc_port: 9160
rpc_keepalive: true
rpc_server_type: sync
thrift_framed_transport_size_in_mb: 15
incremental_backups: false
snapshot_before_compaction: false
auto_snapshot: true
tombstone_warn_threshold: 1000
tombstone_failure_threshold: 100000
column_index_size_in_kb: 64
batch_size_warn_threshold_in_kb: 5
batch_size_fail_threshold_in_kb: 50
unlogged_batch_across_partitions_warn_threshold: 10
compaction_throughput_mb_per_sec: 16
compaction_large_partition_warning_threshold_mb: 100
sstable_preemptive_open_interval_in_mb: 50
read_request_timeout_in_ms: 5000
range_request_timeout_in_ms: 10000
write_request_timeout_in_ms: 2000
counter_write_request_timeout_in_ms: 5000
cas_contention_timeout_in_ms: 1000
truncate_request_timeout_in_ms: 60000
request_timeout_in_ms: 10000
cross_node_timeout: false
endpoint_snitch: GossipingPropertyFileSnitch
dynamic_snitch_update_interval_in_ms: 100
dynamic_snitch_reset_interval_in_ms: 600000
dynamic_snitch_badness_threshold: 0.1
request_scheduler: org.apache.cassandra.scheduler.NoScheduler
server_encryption_options:
  internode_encryption: none
  keystore: conf/.keystore
  keystore_password: cassandra
  truststore: conf/.truststore
  truststore_password: cassandra
client_encryption_options:
  enabled: false
  optional: false
  keystore: conf/.keystore
  keystore_password: cassandra
internode_compression: dc
inter_dc_tcp_nodelay: false
tracetype_query_ttl: 86400
tracetype_repair_ttl: 604800
gc_warn_threshold_in_ms: 1000
enable_user_defined_functions: false
enable_scripted_user_defined_functions: false
windows_timer_interval: 1
EOF

# Configure GossipingPropertyFileSnitch for multi-region deployments
cat > /etc/cassandra/cassandra-rackdc.properties << EOF
dc=dc1
rack=rack1
prefer_local=true
EOF

# Update JVM settings for production use
cat > /etc/cassandra/jvm.options.d/jvm-server-options.options << EOF
-Xms2G
-Xmx2G
-XX:+UseG1GC
-XX:G1RSetUpdatingPauseTimePercent=5
-XX:MaxGCPauseMillis=500
-XX:+PrintGCDetails
-XX:+PrintGCDateStamps
-XX:+PrintHeapAtGC
-XX:+PrintTenuringDistribution
-XX:+PrintGCApplicationStoppedTime
-XX:+PrintPromotionFailure
-XX:+UseGCLogFileRotation
-XX:NumberOfGCLogFiles=10
-XX:GCLogFileSize=10M
EOF

# Set ownership and permissions
chown -R cassandra:cassandra /etc/cassandra

# Start Cassandra
systemctl enable cassandra
systemctl start cassandra

# Wait for Cassandra to start
sleep 30

# Check Cassandra status
nodetool status

echo "Cassandra setup complete!"