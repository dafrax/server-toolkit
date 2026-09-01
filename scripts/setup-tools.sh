#!/usr/bin/env bash
# =============================================================================
# setup-tools.sh — Essential Sysadmin / SRE Tools
# Supported: RHEL, Rocky, AlmaLinux, CentOS Stream, Fedora, Debian, Ubuntu
# =============================================================================
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'
log(){ echo -e "${GREEN}[+]${NC} $*"; }
info(){ echo -e "${BLUE}[*]${NC} $*"; }
warn(){ echo -e "${YELLOW}[!]${NC} $*"; }
err(){ echo -e "${RED}[-]${NC} $*" >&2; }

[[ $EUID -eq 0 ]] || { err "Run as root: sudo $0"; exit 1; }
[[ -f /etc/os-release ]] || { err "/etc/os-release not found"; exit 1; }
source /etc/os-release
log "Detected OS: ${PRETTY_NAME}"

install_rhel(){
  log "Using DNF..."
  case "${ID}" in
    rocky|almalinux|centos)
      log "Enabling EPEL..."
      dnf install -y epel-release || warn "Could not install epel-release; continuing."
      ;;
    rhel)
      if dnf list epel-release >/dev/null 2>&1; then
        log "EPEL package available; enabling EPEL..."
        dnf install -y epel-release || warn "Could not enable EPEL; continuing."
      else
        info "EPEL is not available from enabled RHEL repositories; continuing without it."
      fi
      ;;
    fedora) info "Fedora detected; EPEL is not required." ;;
  esac
  dnf makecache
  dnf install -y \
    vim curl wget git zip unzip tar gzip bzip2 screen tmux \
    htop btop iotop atop fio sysstat iftop iptraf-ng \
    bind-utils net-tools nmap-ncat tcpdump traceroute tcptraceroute mtr \
    jq lsof strace rsync openssh-clients
}

install_debian(){
  log "Using APT..."
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y \
    vim curl wget git zip unzip tar gzip bzip2 screen tmux \
    htop btop iotop atop fio sysstat iftop iptraf-ng \
    dnsutils net-tools netcat-openbsd tcpdump traceroute tcptraceroute mtr-tiny \
    jq lsof strace rsync openssh-client
}

case "${ID}" in
  rhel|rocky|almalinux|centos|fedora) install_rhel ;;
  debian|ubuntu) install_debian ;;
  *) err "Unsupported OS: ${ID}"; exit 1 ;;
esac

log "Verifying tools..."
TOOLS=(vim curl wget git zip unzip tar screen tmux htop btop iotop atop fio iostat iftop iptraf-ng tcpdump traceroute tcptraceroute mtr jq lsof strace rsync ssh)
FAILED=()
for tool in "${TOOLS[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then printf '  %-20s %bOK%b\n' "$tool" "$GREEN" "$NC"; else printf '  %-20s %bMISSING%b\n' "$tool" "$RED" "$NC"; FAILED+=("$tool"); fi
done
if ((${#FAILED[@]})); then warn "Missing tools: ${FAILED[*]}"; exit 1; fi
log "All essential sysadmin/SRE tools are installed successfully."
