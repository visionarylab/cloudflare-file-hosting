action "npm-install" {
  uses = "actions/npm@master"
  args = "ci"
}

action "build" {
  uses = "actions/npm@master"
  needs = ["npm-install"]
  args = "run dist"
}

workflow "push" {
  on = "push"
  resolves = ["build"]
}

workflow "release" {
  on = "release"
  resolves = [
    "publish"
  ]
}

action "release-filter published" {
  uses = "actions/bin/filter@master"
  args = "action published"
}

action "publish" {
  args = "publish --access public"
  needs = ["fix-shebang", "release-filter published"]
  uses = "actions/npm@master"
  secrets = ["NPM_AUTH_TOKEN"]
}

action "fix-shebang" {
  uses = "./.github/docker/fix-shebang"
  needs = ["build"]
}
