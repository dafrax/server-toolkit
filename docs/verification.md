# Installation Verification

Use this checklist after running `scripts/setup-tools.sh`.

## Safe Verification

The installer checks whether each command is available. You can repeat the check without installing packages:

```bash
commands=(vim curl wget git tmux htop btop iotop fio iostat iftop iptraf-ng tcpdump traceroute tcptraceroute mtr jq lsof strace rsync ssh)

for command in "${commands[@]}"; do
  if command -v "$command" >/dev/null 2>&1; then
    printf '%-20s OK\n' "$command"
  else
    printf '%-20s MISSING\n' "$command"
  fi
done
```

## Smoke Tests

Run read-only checks first:

```bash
curl --version
git --version
ssh -V
jq --version
iostat -V
```

For network diagnostics, use a host you are authorized to test:

```bash
dig example.com
mtr --report --report-cycles 3 example.com
nc -vz example.com 443
```

## Storage Benchmark Safety

Do not point `fio` at a production block device. Use a temporary file and confirm the path before running a benchmark:

```bash
test -d /tmp && fio --name=read-check \
  --filename=/tmp/fio-test \
  --size=256M \
  --rw=read \
  --bs=1M \
  --iodepth=1 \
  --runtime=10 \
  --time_based
rm -f /tmp/fio-test
```

## Troubleshooting

- If a command is missing, inspect the package mapping in `README.md`.
- On Debian-family systems, package names can differ between Ubuntu releases.
- On RHEL-family systems, verify enabled repositories before retrying installation.
- Run the installer only on systems where you have root permission and change approval.
