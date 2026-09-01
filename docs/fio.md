### Disk I/O

Check disk utilization:

```bash
iostat -xz 1 10
```

Monitor per-process disk I/O:

```bash
iotop -oPa
```

### FIO Quick Test

Run a quick read test using a temporary file:

```bash
fio --name=quick-read \
  --filename=/tmp/fio-test \
  --size=1G \
  --rw=read \
  --bs=1M \
  --iodepth=16 \
  --runtime=30 \
  --time_based \
  --direct=1 \
  --group_reporting
```

### FIO Sequential Read

Useful for checking sequential read throughput:

```bash
fio --name=seq-read \
  --filename=/tmp/fio-test \
  --size=2G \
  --rw=read \
  --bs=1M \
  --iodepth=32 \
  --runtime=60 \
  --time_based \
  --direct=1 \
  --group_reporting
```

### FIO Sequential Write

Useful for checking sequential write throughput:

```bash
fio --name=seq-write \
  --filename=/tmp/fio-test \
  --size=2G \
  --rw=write \
  --bs=1M \
  --iodepth=32 \
  --runtime=60 \
  --time_based \
  --direct=1 \
  --group_reporting
```

> **Warning:** This test writes data to the target file. Make sure the target has sufficient free space and that the file does not contain important data.

### FIO Random Read

Useful for checking random read IOPS:

```bash
fio --name=rand-read \
  --filename=/tmp/fio-test \
  --size=2G \
  --rw=randread \
  --bs=4k \
  --iodepth=32 \
  --runtime=60 \
  --time_based \
  --direct=1 \
  --group_reporting
```

### FIO Random Write

Useful for checking random write IOPS:

```bash
fio --name=rand-write \
  --filename=/tmp/fio-test \
  --size=2G \
  --rw=randwrite \
  --bs=4k \
  --iodepth=32 \
  --runtime=60 \
  --time_based \
  --direct=1 \
  --group_reporting
```

> **Warning:** This test performs writes. Do not point `--filename` directly at a production block device such as `/dev/sda`, `/dev/nvme0n1`, an LVM volume, or a mounted production device.

### FIO Mixed Random Read/Write

Useful for simulating mixed application workloads:

```bash
fio --name=rand-rw \
  --filename=/tmp/fio-test \
  --size=2G \
  --rw=randrw \
  --rwmixread=70 \
  --bs=4k \
  --iodepth=32 \
  --runtime=60 \
  --time_based \
  --direct=1 \
  --group_reporting
```

### FIO Latency Test

Useful for checking storage latency:

```bash
fio --name=latency \
  --filename=/tmp/fio-test \
  --size=1G \
  --rw=randread \
  --bs=4k \
  --iodepth=1 \
  --runtime=30 \
  --time_based \
  --direct=1 \
  --group_reporting
```

### Cleanup

Remove the temporary benchmark file:

```bash
rm -f /tmp/fio-test
```

### FIO Test Parameters

| Parameter           | Description                       |
| ------------------- | --------------------------------- |
| `--rw=read`         | Sequential read                   |
| `--rw=write`        | Sequential write                  |
| `--rw=randread`     | Random read                       |
| `--rw=randwrite`    | Random write                      |
| `--rw=randrw`       | Mixed random read/write           |
| `--bs=4k`           | I/O block size                    |
| `--bs=1M`           | 1 MiB block size                  |
| `--iodepth=1`       | Low queue depth / latency test    |
| `--iodepth=32`      | Higher queue depth                |
| `--direct=1`        | Direct I/O, bypass page cache     |
| `--runtime=60`      | Test duration                     |
| `--time_based`      | Run for the specified duration    |
| `--group_reporting` | Combine output for easier reading |

### Interpreting FIO Results

Important values in the output include:

```text
IOPS
BW
clat
lat
```

**IOPS**

Number of I/O operations completed per second.

**BW**

Storage throughput, normally shown in MiB/s or GiB/s.

**clat**

Completion latency of individual I/O operations.

**lat**

Overall I/O latency.

For troubleshooting, compare the results with the expected performance of the underlying storage type, such as:

* HDD
* SATA SSD
* NVMe
* network storage
* EBS
* SAN
* Ceph
* other distributed/block storage

> FIO results are workload-dependent. A 4K random test measures something very different from a 1M sequential test. Always compare like-for-like workloads.
