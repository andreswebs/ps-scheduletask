# ps-scheduletask

PowerShell script: creates a scheduled task to run an existing script at machine
start.

## Examples

### With Packer

When using with the Packer `powershell` provisioner, set parameters as environment variables:

```hcl
provisioner "file" {
  source      = "${path.root}/env-tasks/"
  destination = "C:\\env-tasks"
}

provisioner "powershell" {
  environment_vars = [
    "TASK_NAME=DoMyThing",
    "TASK_SCRIPT_PATH=C:\\env-tasks\\do-my-thing.ps1",
    "TASK_SELF_UNREGISTER=yes",
  ]
  scripts = [
    "${local.scripts}/schedule-task.ps1",
  ]
}
```

## Authors

**Andre Silva** - [@andreswebs](https://github.com/andreswebs)

## License

This project is licensed under the [Unlicense](UNLICENSE.md).
