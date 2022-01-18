{{ $rookNamespace := namespace "rook" }}
{{ $creds := secret $rookNamespace "rook-ceph-dashboard-password" }}
You can view your Ceph Dashboard at https://{{ .Values.hostname }}
The Ceph S3 is accessible at https://{{ .Values.s3Hostname }}

Your initial admin credentials are:

Username: admin
Password: {{ $creds.password }}
