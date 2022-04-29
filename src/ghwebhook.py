import os
import sys
import git
from git import RemoteProgress
from hmac import HMAC, compare_digest, new
from hashlib import sha256

class CloneProgress(RemoteProgress):
    def update(self, op_code, cur_count, max_count=None, message=""):
        if message:
            print(message)


def verify_signature(req, sec):
    received_sign = req.headers.get("X-Hub-Signature-256").split("sha256=")[-1].strip()
    expected_sign = HMAC(key=sec.encode(), msg=req.data, digestmod=sha256).hexdigest()
    print(expected_sign)
    return compare_digest(received_sign, expected_sign)


def checkoutAndDeploy(git_url, repo_dir):
    git.Repo.clone_from(git_url, repo_dir, branch="master", progress=CloneProgress())
    print(f"Clone done. {git_url}")
