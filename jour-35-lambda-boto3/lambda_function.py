import boto3

def lambda_handler(event, context):
    ec2 = boto3.client("ec2", region_name="us-east-1")
    account_id = boto3.client("sts").get_caller_identity()["Account"]
    snapshots = ec2.describe_snapshots(OwnerIds=[account_id])["Snapshots"]
    print("Total snapshots : " + str(len(snapshots)))
    volumes_actifs = set()
    for v in ec2.describe_volumes()["Volumes"]:
        volumes_actifs.add(v["VolumeId"])
    supprimes = 0
    for snap in snapshots:
        vol_id = snap.get("VolumeId", "")
        snap_id = snap["SnapshotId"]
        if vol_id and vol_id not in volumes_actifs:
            print("SUPPRIME : " + snap_id)
            supprimes += 1
        else:
            print("GARDE : " + snap_id)
    return {"total": len(snapshots), "supprimes": supprimes}
