### Sample Windows BOSH Release

This release will deploy a simple job to `say-hello` for windows


Sample manifest:

```
name: say-hello

releases:
- name: sample-windows-bosh-release
  version: latest

stemcells:
- alias: windows
  os: windows2012R2
  version: latest

update:
  canaries: 1
  canary_watch_time: 30000-300000
  update_watch_time: 30000-300000
  max_in_flight: 1
  max_errors: 2
  serial: false

instance_groups:
- name: hello
  stemcell: windows
  vm_type: {{REPLACE_ME}}
  vm_extensions:
  - {{REPLACE_ME}}
  azs: [{{REPLACE_ME}}]
  networks:
  - name: {{REPLACE_ME}}
  jobs:
  - name: say-hello
    release: sample-windows-bosh-release
  instances: 1
  lifecycle: service
```
