# vanity_worker.py (fast core-optimized)
import base58
import time
from solders.keypair import Keypair
from multiprocessing import Process, cpu_count
import sys
import os

prefix = sys.argv[1]
result_file = f"vanity_result_{prefix}.txt"

def search_loop(core_id):
    count = 0
    start_time = time.time()

    while True:
        kp = Keypair()
        pubkey = str(kp.pubkey())
        count += 1

        if pubkey.startswith(prefix):
            elapsed = time.time() - start_time
            with open(result_file, "w") as f:
                f.write(f"Public Key:  {pubkey}\n")
                f.write(f"Private Key: {base58.b58encode(kp.to_bytes()).decode()}\n")
                f.write(f"Attempts:    {count}\n")
                f.write(f"Time:        {elapsed:.2f} seconds\n")
                f.write(f"Core:        {core_id}\n")
            break

def main():
    processes = []
    for i in range(cpu_count()):
        p = Process(target=search_loop, args=(i,))
        p.start()
        processes.append(p)

    for p in processes:
        p.join()

if __name__ == "__main__":
    main()

