# Solana Vanity Address Cluster

This project lets you search for Solana vanity addresses using a cluster of Mac Minis. The search is parallelized across all available CPU cores in the cluster. Once any node finds a matching address, the cluster terminates the search on all other nodes and returns the result.

## Project Structure

- **vanity_worker.py**: Python script to search for Solana vanity addresses using all CPU cores on a single Mac Mini.
- **vanity_cluster.sh**: Bash script to distribute and manage the search job across multiple Mac Minis in your network.

---

## Prerequisites

- **Python 3** installed on all Mac Minis
- Required Python packages (see below)
- SSH access set up between controller and all Mac Minis (e.g., `ssh nock1`, `ssh nock2`, ...)
- Mac Minis should have hostnames: `nock1` to `nock9` (edit the `HOSTS` array in the script if needed)

---

## Setup Instructions

### 1. Clone the repository and copy files

On your controller Mac (the one you use to manage the cluster):

```bash
git clone https://github.com/0xdarkcap/solana-vanity-cluster.git
cd solana-vanity-cluster
```

Copy `vanity_worker.py` to the home directory of each Mac Mini:

```bash
for host in nock1 nock2 nock3 nock4 nock5 nock6 nock7 nock8 nock9; do
    scp vanity_worker.py $host:~/
done
```

### 2. Install Python dependencies

SSH into each Mac Mini and run:

```bash
pip3 install base58 solders
```
Or 
```bash
for host in nock1 nock2 nock3 nock4 nock5 nock6 nock7 nock8 nock9; do
    ssh $host "pip3 install base58 solders"
done
```
to istall dependencies in each mac mini, change the hostnames accordingly. 

Or, if no requirements file is present, install needed packages individually.

### 3. Make the cluster script executable

```bash
chmod +x vanity_cluster.sh
```

---

## Usage

Run the cluster search from your controller Mac:

```bash
./vanity_cluster.sh <PREFIX>
```

- Replace `<PREFIX>` with your desired Solana address prefix (e.g., `sol`, `truth`, etc.).

The script will:
- Launch the worker on all nodes.
- Monitor for the first match.
- Collect the result and terminate all running workers once a match is found.

---

## Notes

- **Hostnames**: If your Mac Minis use different hostnames or you have fewer nodes, edit the `HOSTS` array in `vanity_cluster.sh`.
- **Result**: The result (private/public key) will be printed to your terminal when found.
- **Security**: Handle private keys securely. Do not expose them in shared or insecure environments.

---

## License

MIT License
