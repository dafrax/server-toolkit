# Server Toolkit

Essential command-line toolkit for Linux server administration, SRE, troubleshooting, networking, storage diagnostics, and performance analysis.

## Supported OS

* RHEL 8/9/10
* Rocky Linux
* AlmaLinux
* CentOS Stream
* Fedora
* Debian
* Ubuntu

## What is included

### System & process

* `vim` — editor
* `htop`, `btop`, `atop` — process/system monitoring
* `screen`, `tmux` — persistent terminal sessions

### Storage & performance

* `fio` — storage benchmark
* `iostat` — CPU and disk I/O statistics (`sysstat`)
* `iotop` — per-process I/O
* `lsof` — open files/devices

### Network troubleshooting

* `iftop` — bandwidth by connection
* `iptraf-ng` — interface/traffic analysis
* `tcpdump` — packet capture
* `traceroute` — route tracing
* `tcptraceroute` — TCP route tracing, useful for ports such as 443
* `mtr` — latency/loss analysis
* `nc` / `ncat` — connectivity testing
* `dig`, `nslookup` — DNS diagnostics

### Debugging & operations

* `strace` — syscall tracing
* `jq` — JSON processing
* `rsync` — file synchronization
* `curl`, `wget` — HTTP/download testing
* `git` — source control
* `ssh` — remote administration

## Quick install

Install the complete toolkit directly using the package manager.

### RHEL / Rocky Linux / AlmaLinux / CentOS Stream / Fedora

#### DNF

```bash
sudo dnf install -y vim curl wget git zip unzip tar gzip bzip2 screen tmux htop btop iotop atop fio sysstat iftop iptraf-ng bind-utils net-tools nmap-ncat tcpdump traceroute tcptraceroute mtr jq lsof strace rsync openssh-clients
```

#### YUM

For older RHEL/CentOS systems:

```bash
sudo yum install -y vim curl wget git zip unzip tar gzip bzip2 screen tmux htop iotop atop fio sysstat iftop iptraf-ng bind-utils net-tools nmap-ncat tcpdump traceroute tcptraceroute mtr jq lsof strace rsync openssh-clients
```

### Debian / Ubuntu

```bash
sudo apt update && sudo apt install -y vim curl wget git zip unzip tar gzip bzip2 screen tmux htop btop iotop atop fio sysstat iftop iptraf-ng dnsutils net-tools netcat-openbsd tcpdump traceroute tcptraceroute mtr-tiny jq lsof strace rsync openssh-client
```

> Package names differ between distributions. See [Package mapping](#package-mapping).

## Quick install script

The repository includes an installer that automatically detects the operating system and installs the appropriate packages.

```bash
sudo ./scripts/setup-tools.sh
```

Or:

```bash
sudo bash scripts/setup-tools.sh
```

The installer supports:

* RHEL
* Rocky Linux
* AlmaLinux
* CentOS Stream
* Fedora
* Debian
* Ubuntu

The installer is safe to re-run.

### Clone and install

```bash
git clone https://github.com/dafrax/server-toolkit.git
cd sysadmin-tools
sudo ./scripts/setup-tools.sh
```

## Package manager policy

This repository supports:

* `dnf` for modern RHEL-family systems
* `yum` for legacy RHEL/CentOS systems
* `apt` for Debian-family systems

Modern RHEL-family distributions should use `dnf`.

`yum` is retained only for compatibility with older systems.

## EPEL policy

EPEL is enabled only for RHEL-family distributions where it is appropriate/available.

* Rocky Linux: enabled
* AlmaLinux: enabled
* CentOS Stream: enabled
* RHEL: enabled only when `epel-release` is available from configured repositories
* Fedora: not required
* Debian/Ubuntu: not applicable

If EPEL cannot be enabled, the script continues and attempts to install the standard package set.

For manual installation on Rocky Linux, AlmaLinux, or CentOS Stream:

```bash
sudo dnf install -y epel-release
```

Then install the toolkit:

```bash
sudo dnf install -y vim curl wget git zip unzip tar gzip bzip2 screen tmux htop btop iotop atop fio sysstat iftop iptraf-ng bind-utils net-tools nmap-ncat tcpdump traceroute tcptraceroute mtr jq lsof strace rsync openssh-clients
```

## Package mapping

| Purpose         | RHEL / Fedora            | Debian / Ubuntu    |
| --------------- | ------------------------ | ------------------ |
| DNS tools       | `bind-utils`             | `dnsutils`         |
| Netcat          | `nmap-ncat`              | `netcat-openbsd`   |
| MTR             | `mtr`                    | `mtr-tiny`         |
| Locate database | not explicitly installed | `plocate` optional |
| SSH client      | `openssh-clients`        | `openssh-client`   |
| I/O statistics  | `sysstat`                | `sysstat`          |

## Common commands

### Disk I/O

```bash
iostat -xz 1 10
```

```bash
iotop -oPa
```

```bash
fio --name=test --filename=/tmp/fio-test --size=1G --rw=randread --bs=4k --iodepth=32 --runtime=30 --time_based
```

> Do not run destructive `fio` tests against production disks or block devices. The example above uses a file under `/tmp`, but still verify the target before running benchmarks.

### Network

```bash
mtr -rw example.com
```

```bash
tcptraceroute example.com 443
```

```bash
nc -vz example.com 443
```

```bash
curl -vk https://example.com/
```

```bash
tcpdump -ni any port 443
```

### Process / file diagnostics

```bash
htop
```

```bash
lsof -i :443
```

```bash
strace -p <PID>
```

## Repository layout

```text
sysadmin-tools/
├── README.md
├── LICENSE
├── .gitignore
├── Makefile
├── scripts/
│   └── setup-tools.sh
└── docs/
    └── tools.md
    └── fio.md
```

## Design principles

1. Keep the base toolkit small and useful.
2. Prefer packages available from the distribution repositories.
3. Use EPEL only when needed on RHEL-family systems.
4. Keep RHEL and Debian package names mapped explicitly.
5. Avoid application-specific tools such as `mytop` in the base toolkit.
6. Make the installer safe to re-run.
