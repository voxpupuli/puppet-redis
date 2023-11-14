# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v9.3.0](https://github.com/voxpupuli/puppet-redis/tree/v9.3.0) (2023-11-14)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v9.2.0...v9.3.0)

**Implemented enhancements:**

- Add Puppet 8 support [\#484](https://github.com/voxpupuli/puppet-redis/pull/484) ([bastelfreak](https://github.com/bastelfreak))

## [v9.2.0](https://github.com/voxpupuli/puppet-redis/tree/v9.2.0) (2023-11-03)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v9.1.0...v9.2.0)

**Implemented enhancements:**

- Allow puppet/systemd 6.x [\#490](https://github.com/voxpupuli/puppet-redis/pull/490) ([evgeni](https://github.com/evgeni))

**Merged pull requests:**

- fix spelling of "redis dnf module" [\#491](https://github.com/voxpupuli/puppet-redis/pull/491) ([evgeni](https://github.com/evgeni))

## [v9.1.0](https://github.com/voxpupuli/puppet-redis/tree/v9.1.0) (2023-07-29)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v9.0.0...v9.1.0)

**Implemented enhancements:**

- puppetlabs/stdlib: Allow 9.x [\#483](https://github.com/voxpupuli/puppet-redis/pull/483) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Add Rocky/AlmaLinux support [\#487](https://github.com/voxpupuli/puppet-redis/pull/487) ([bastelfreak](https://github.com/bastelfreak))
- Specify environment module path for bolt [\#475](https://github.com/voxpupuli/puppet-redis/pull/475) ([traylenator](https://github.com/traylenator))

## [v9.0.0](https://github.com/voxpupuli/puppet-redis/tree/v9.0.0) (2023-06-01)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v8.8.0...v9.0.0)

**Breaking changes:**

- Drop EoL Debian 9 support [\#469](https://github.com/voxpupuli/puppet-redis/pull/469) ([bastelfreak](https://github.com/bastelfreak))
- Drop Puppet 6 support [\#468](https://github.com/voxpupuli/puppet-redis/pull/468) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add param to pass to apt-key adv [\#466](https://github.com/voxpupuli/puppet-redis/pull/466) ([pwf](https://github.com/pwf))

**Fixed bugs:**

- Fix missing puppet strings [\#481](https://github.com/voxpupuli/puppet-redis/pull/481) ([ghoneycutt](https://github.com/ghoneycutt))
- Fix for redis.conf.epp bug: save\_db\_to\_disk = false does not work.  [\#478](https://github.com/voxpupuli/puppet-redis/pull/478) ([pankajr](https://github.com/pankajr))

**Closed issues:**

- save\_db\_to\_disk = false does not work [\#477](https://github.com/voxpupuli/puppet-redis/issues/477)
- Support deferred values for requirepass [\#473](https://github.com/voxpupuli/puppet-redis/issues/473)
- Replace `slaveof` with `replicaof` [\#401](https://github.com/voxpupuli/puppet-redis/issues/401)

**Merged pull requests:**

- Allow deferrables for masterauth & requirepass [\#476](https://github.com/voxpupuli/puppet-redis/pull/476) ([ThiefMaster](https://github.com/ThiefMaster))
- CI: Switch sysctl module to new namespace & cleanup .fixtures.yml [\#471](https://github.com/voxpupuli/puppet-redis/pull/471) ([bastelfreak](https://github.com/bastelfreak))
- Drop Puppet 6 CI leftovers [\#470](https://github.com/voxpupuli/puppet-redis/pull/470) ([bastelfreak](https://github.com/bastelfreak))
- add replicaof parameter\(v2\) [\#465](https://github.com/voxpupuli/puppet-redis/pull/465) ([jonasbartho](https://github.com/jonasbartho))

## [v8.8.0](https://github.com/voxpupuli/puppet-redis/tree/v8.8.0) (2023-01-27)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v8.7.0...v8.8.0)

**Implemented enhancements:**

- bump puppet/systemd to \< 5.0.0 [\#463](https://github.com/voxpupuli/puppet-redis/pull/463) ([jhoblitt](https://github.com/jhoblitt))

**Fixed bugs:**

- add missing default config\_file\_orig for SUSE [\#462](https://github.com/voxpupuli/puppet-redis/pull/462) ([lbetz](https://github.com/lbetz))

## [v8.7.0](https://github.com/voxpupuli/puppet-redis/tree/v8.7.0) (2022-12-09)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v8.6.0...v8.7.0)

**Implemented enhancements:**

- Allow custom replica announce IP/port and Sentinel announce IP [\#459](https://github.com/voxpupuli/puppet-redis/pull/459) ([pierre-claranet](https://github.com/pierre-claranet))

## [v8.6.0](https://github.com/voxpupuli/puppet-redis/tree/v8.6.0) (2022-12-05)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v8.5.0...v8.6.0)

**Implemented enhancements:**

- Add support for managing Redis APT repo [\#456](https://github.com/voxpupuli/puppet-redis/pull/456) ([zaben903](https://github.com/zaben903))

## [v8.5.0](https://github.com/voxpupuli/puppet-redis/tree/v8.5.0) (2022-10-28)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v8.4.0...v8.5.0)

**Implemented enhancements:**

- Use a single regular expression in the Redis fact [\#451](https://github.com/voxpupuli/puppet-redis/pull/451) ([ekohl](https://github.com/ekohl))
- Add support for managing Redis dnfmodule on EL 8+ [\#450](https://github.com/voxpupuli/puppet-redis/pull/450) ([ehelms](https://github.com/ehelms))

**Merged pull requests:**

- Fix get function tests [\#452](https://github.com/voxpupuli/puppet-redis/pull/452) ([ehelms](https://github.com/ehelms))

## [v8.4.0](https://github.com/voxpupuli/puppet-redis/tree/v8.4.0) (2022-05-31)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v8.3.0...v8.4.0)

**Implemented enhancements:**

- Add support for systemd service timeouts [\#447](https://github.com/voxpupuli/puppet-redis/pull/447) ([fraenki](https://github.com/fraenki))
- Add support for Redis6 features [\#445](https://github.com/voxpupuli/puppet-redis/pull/445) ([fraenki](https://github.com/fraenki))

**Closed issues:**

- Rediscluster on Ubuntu 20.04 [\#402](https://github.com/voxpupuli/puppet-redis/issues/402)

## [v8.3.0](https://github.com/voxpupuli/puppet-redis/tree/v8.3.0) (2022-04-04)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v8.2.0...v8.3.0)

**Implemented enhancements:**

- Add tls settings to the redis::sentinel class and the redis-sentinel.conf template [\#443](https://github.com/voxpupuli/puppet-redis/pull/443) ([tparkercbn](https://github.com/tparkercbn))
- Add Debian 11 support [\#440](https://github.com/voxpupuli/puppet-redis/pull/440) ([ekohl](https://github.com/ekohl))
- Drop default PPA setting and only install EPEL on EL7 [\#435](https://github.com/voxpupuli/puppet-redis/pull/435) ([ekohl](https://github.com/ekohl))
- CentOS9/RHEL9: Migrate configuration files to /etc/redis [\#434](https://github.com/voxpupuli/puppet-redis/pull/434) ([kajinamit](https://github.com/kajinamit))
- conditional instance restarts on config file changes [\#433](https://github.com/voxpupuli/puppet-redis/pull/433) ([aamerik](https://github.com/aamerik))
- manage additional redis modules [\#426](https://github.com/voxpupuli/puppet-redis/pull/426) ([ymartin-ovh](https://github.com/ymartin-ovh))
- service\_template RuntimeDirectory [\#424](https://github.com/voxpupuli/puppet-redis/pull/424) ([aamerik](https://github.com/aamerik))

**Fixed bugs:**

- Fix issue redis.conf being world readable [\#427](https://github.com/voxpupuli/puppet-redis/pull/427) ([jnguiot](https://github.com/jnguiot))

**Closed issues:**

- Single instance systemd service won't start on Arch Linux [\#439](https://github.com/voxpupuli/puppet-redis/issues/439)

**Merged pull requests:**

- Drop Archlinux support [\#441](https://github.com/voxpupuli/puppet-redis/pull/441) ([ekohl](https://github.com/ekohl))
- Fix running acceptance tests in non-Docker environments [\#437](https://github.com/voxpupuli/puppet-redis/pull/437) ([ekohl](https://github.com/ekohl))
- Correct docs on redis::get & regenerate REFERENCE.md [\#436](https://github.com/voxpupuli/puppet-redis/pull/436) ([ekohl](https://github.com/ekohl))

## [v8.2.0](https://github.com/voxpupuli/puppet-redis/tree/v8.2.0) (2021-10-13)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v8.1.1...v8.2.0)

**Implemented enhancements:**

- allow bin\_path overrides for custom redis installs [\#423](https://github.com/voxpupuli/puppet-redis/pull/423) ([aamerik](https://github.com/aamerik))
- Add TLS support [\#421](https://github.com/voxpupuli/puppet-redis/pull/421) ([aamerik](https://github.com/aamerik))

**Fixed bugs:**

- Skip ensuring package if sentinel requires no additional package [\#417](https://github.com/voxpupuli/puppet-redis/pull/417) ([kajinamit](https://github.com/kajinamit))

## [v8.1.1](https://github.com/voxpupuli/puppet-redis/tree/v8.1.1) (2021-08-30)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v8.1.0...v8.1.1)

**Fixed bugs:**

- Honor redis::sentinel::package\_ensure [\#413](https://github.com/voxpupuli/puppet-redis/pull/413) ([kajinamit](https://github.com/kajinamit))

## [v8.1.0](https://github.com/voxpupuli/puppet-redis/tree/v8.1.0) (2021-08-29)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v8.0.0...v8.1.0)

**Implemented enhancements:**

- Ability to disable slowlog\_log\_slower\_than [\#404](https://github.com/voxpupuli/puppet-redis/issues/404)
- Allow disable to disable slow log [\#414](https://github.com/voxpupuli/puppet-redis/pull/414) ([root-expert](https://github.com/root-expert))
- Use Puppet-Datatype Sensitive for $masterauth and $auth\_pass [\#403](https://github.com/voxpupuli/puppet-redis/pull/403) ([cocker-cc](https://github.com/cocker-cc))

**Merged pull requests:**

- Allow stdlib 8.0.0 [\#411](https://github.com/voxpupuli/puppet-redis/pull/411) ([smortex](https://github.com/smortex))

## [v8.0.0](https://github.com/voxpupuli/puppet-redis/tree/v8.0.0) (2021-07-24)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v7.0.0...v8.0.0)

**Breaking changes:**

- Use EPP for Configfile [\#407](https://github.com/voxpupuli/puppet-redis/pull/407) ([cocker-cc](https://github.com/cocker-cc))
- Drop Ubuntu 16.04 support [\#406](https://github.com/voxpupuli/puppet-redis/pull/406) ([ekohl](https://github.com/ekohl))
- Drop Puppet 5 support [\#392](https://github.com/voxpupuli/puppet-redis/pull/392) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Adding ability to secure Sentinel [\#399](https://github.com/voxpupuli/puppet-redis/pull/399) ([markasammut](https://github.com/markasammut))

**Fixed bugs:**

- set correct redis bin path in systemd for instances when using SCL [\#405](https://github.com/voxpupuli/puppet-redis/pull/405) ([alexskr](https://github.com/alexskr))

**Closed issues:**

- Missing ability to secure sentinel? [\#305](https://github.com/voxpupuli/puppet-redis/issues/305)

**Merged pull requests:**

- switch from camptocamp/systemd to voxpupuli/systemd [\#408](https://github.com/voxpupuli/puppet-redis/pull/408) ([bastelfreak](https://github.com/bastelfreak))

## [v7.0.0](https://github.com/voxpupuli/puppet-redis/tree/v7.0.0) (2021-04-28)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v6.1.0...v7.0.0)

**Breaking changes:**

- Remove support for THP in Redis module - recommend forge module [\#385](https://github.com/voxpupuli/puppet-redis/pull/385) ([dom-nie](https://github.com/dom-nie))
- Drop sysinit /CentOS 6 support [\#382](https://github.com/voxpupuli/puppet-redis/pull/382) ([ekohl](https://github.com/ekohl))
- Make augeasproviders\_sysctl a soft dependency [\#377](https://github.com/voxpupuli/puppet-redis/pull/377) ([ekohl](https://github.com/ekohl))
- Move package parameters to init.pp [\#374](https://github.com/voxpupuli/puppet-redis/pull/374) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Declare Puppet 7 support [\#400](https://github.com/voxpupuli/puppet-redis/pull/400) ([ekohl](https://github.com/ekohl))
- Set ulimit via systemd using camptocamp/systemd [\#396](https://github.com/voxpupuli/puppet-redis/pull/396) ([ekohl](https://github.com/ekohl))
- puppetlabs/stdlib: Allow 7.x [\#394](https://github.com/voxpupuli/puppet-redis/pull/394) ([bastelfreak](https://github.com/bastelfreak))
- Allow relative paths for $log\_file [\#387](https://github.com/voxpupuli/puppet-redis/pull/387) ([ekohl](https://github.com/ekohl))
- Add support for rename-command in redis.conf [\#383](https://github.com/voxpupuli/puppet-redis/pull/383) ([carlhals](https://github.com/carlhals))
- enable sentinel bind usage with multi ip [\#365](https://github.com/voxpupuli/puppet-redis/pull/365) ([ragingdave](https://github.com/ragingdave))
- Make protected-mode configurable for sentinel [\#272](https://github.com/voxpupuli/puppet-redis/pull/272) ([eliskovets](https://github.com/eliskovets))

**Fixed bugs:**

- Set the correct log dir on RH SCL [\#379](https://github.com/voxpupuli/puppet-redis/pull/379) ([ekohl](https://github.com/ekohl))
- Drop dotdeb repo management support [\#371](https://github.com/voxpupuli/puppet-redis/pull/371) ([ekohl](https://github.com/ekohl))
- Correct config\_dir for scl support [\#353](https://github.com/voxpupuli/puppet-redis/pull/353) ([markasammut](https://github.com/markasammut))

**Closed issues:**

- Make ulimit optional or use puppet-systemd for dropin [\#390](https://github.com/voxpupuli/puppet-redis/issues/390)
- After a reboot THP \(Transparent Huge Pages\) are enabled again [\#372](https://github.com/voxpupuli/puppet-redis/issues/372)
- File descriptor limit is not set in systemd unit file by default.  [\#349](https://github.com/voxpupuli/puppet-redis/issues/349)
- Redhat SCL Config\_Dir Issue [\#341](https://github.com/voxpupuli/puppet-redis/issues/341)
- \[Feature Request\] Add `rename-command` [\#242](https://github.com/voxpupuli/puppet-redis/issues/242)
- Undefined variable 'redis\_server\_version' warning on first run [\#227](https://github.com/voxpupuli/puppet-redis/issues/227)

**Merged pull requests:**

- Make spec\_helper.rb managed again [\#380](https://github.com/voxpupuli/puppet-redis/pull/380) ([ekohl](https://github.com/ekohl))
- Add type alias tests to data types [\#366](https://github.com/voxpupuli/puppet-redis/pull/366) ([ekohl](https://github.com/ekohl))

## [v6.1.0](https://github.com/voxpupuli/puppet-redis/tree/v6.1.0) (2020-09-11)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v6.0.0...v6.1.0)

**Implemented enhancements:**

- Add Ubuntu 20.04 support [\#357](https://github.com/voxpupuli/puppet-redis/pull/357) ([mmoll](https://github.com/mmoll))

## [v6.0.0](https://github.com/voxpupuli/puppet-redis/tree/v6.0.0) (2020-05-11)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v5.0.0...v6.0.0)

**Breaking changes:**

- Make apt and epel soft dependencies [\#358](https://github.com/voxpupuli/puppet-redis/pull/358) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Add support for RedHat/CentOS 8 [\#350](https://github.com/voxpupuli/puppet-redis/pull/350) ([yakatz](https://github.com/yakatz))
- Add Debian 10 support [\#344](https://github.com/voxpupuli/puppet-redis/pull/344) ([ekohl](https://github.com/ekohl))
- Finishing touches for multi-instance support [\#343](https://github.com/voxpupuli/puppet-redis/pull/343) ([fraenki](https://github.com/fraenki))
- Set RuntimeDirectory in service template [\#342](https://github.com/voxpupuli/puppet-redis/pull/342) ([basti-nis](https://github.com/basti-nis))

**Fixed bugs:**

- change systemd stop command to redis-cli [\#355](https://github.com/voxpupuli/puppet-redis/pull/355) ([alexskr](https://github.com/alexskr))
- Fix the sentinel pid file location for Ubuntu 18.04 [\#347](https://github.com/voxpupuli/puppet-redis/pull/347) ([ekohl](https://github.com/ekohl))

**Closed issues:**

- Type forking causes service timeout [\#260](https://github.com/voxpupuli/puppet-redis/issues/260)

**Merged pull requests:**

- Use more native rspec and serverspec testing [\#348](https://github.com/voxpupuli/puppet-redis/pull/348) ([ekohl](https://github.com/ekohl))
- Run acceptance tests with manage\_repo =\> false [\#346](https://github.com/voxpupuli/puppet-redis/pull/346) ([ekohl](https://github.com/ekohl))
- Update bolt testing to use modern versions [\#345](https://github.com/voxpupuli/puppet-redis/pull/345) ([ekohl](https://github.com/ekohl))

## [v5.0.0](https://github.com/voxpupuli/puppet-redis/tree/v5.0.0) (2019-12-03)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v4.2.1...v5.0.0)

**Breaking changes:**

- Closer match parameter to OS defaults [\#336](https://github.com/voxpupuli/puppet-redis/pull/336) ([ekohl](https://github.com/ekohl))
- Stricter data types [\#328](https://github.com/voxpupuli/puppet-redis/pull/328) ([ekohl](https://github.com/ekohl))
- Drop support for Redis 2, Debian 8 and Ubuntu 14.04; add Debian 9 and Ubuntu 18.04 [\#326](https://github.com/voxpupuli/puppet-redis/pull/326) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Instance is not read from hiera file [\#329](https://github.com/voxpupuli/puppet-redis/issues/329)
- Add SCL support [\#334](https://github.com/voxpupuli/puppet-redis/pull/334) ([ekohl](https://github.com/ekohl))
- Support instances inside Hiera [\#330](https://github.com/voxpupuli/puppet-redis/pull/330) ([lordbink](https://github.com/lordbink))

**Closed issues:**

- Can't disable unixsocket after  [\#331](https://github.com/voxpupuli/puppet-redis/issues/331)
- 2.8 version of Redis on Debian 8 errors out [\#246](https://github.com/voxpupuli/puppet-redis/issues/246)
- Unable to unset unixsocket config parameter [\#228](https://github.com/voxpupuli/puppet-redis/issues/228)
- bind $ipaddress [\#94](https://github.com/voxpupuli/puppet-redis/issues/94)
- Create nodes.conf file?  [\#76](https://github.com/voxpupuli/puppet-redis/issues/76)

**Merged pull requests:**

- Clean up preinstall handling and use modern facts [\#335](https://github.com/voxpupuli/puppet-redis/pull/335) ([ekohl](https://github.com/ekohl))
- Allow empty unixsocket\(perm\) [\#333](https://github.com/voxpupuli/puppet-redis/pull/333) ([ekohl](https://github.com/ekohl))
- Allow privileged ports in data types [\#332](https://github.com/voxpupuli/puppet-redis/pull/332) ([ekohl](https://github.com/ekohl))
- Fix typo in type [\#327](https://github.com/voxpupuli/puppet-redis/pull/327) ([ekohl](https://github.com/ekohl))
- Complete the transition to puppet-strings [\#325](https://github.com/voxpupuli/puppet-redis/pull/325) ([ekohl](https://github.com/ekohl))

## [v4.2.1](https://github.com/voxpupuli/puppet-redis/tree/v4.2.1) (2019-09-19)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v4.2.0...v4.2.1)

**Fixed bugs:**

- Fixing repl\_ping\_slave\_period not being managed with params [\#318](https://github.com/voxpupuli/puppet-redis/pull/318) ([dom-nie](https://github.com/dom-nie))

**Merged pull requests:**

- Spelling fix [\#323](https://github.com/voxpupuli/puppet-redis/pull/323) ([tetsuo13](https://github.com/tetsuo13))

## [v4.2.0](https://github.com/voxpupuli/puppet-redis/tree/v4.2.0) (2019-07-22)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v4.1.0...v4.2.0)

**Implemented enhancements:**

- Adding support for more redis cluster params  [\#316](https://github.com/voxpupuli/puppet-redis/pull/316) ([dom-nie](https://github.com/dom-nie))

**Closed issues:**

- Fix systemd service filename [\#310](https://github.com/voxpupuli/puppet-redis/issues/310)
- Fix manage\_service\_file variable [\#308](https://github.com/voxpupuli/puppet-redis/issues/308)

**Merged pull requests:**

- Allow `puppetlabs/stdlib` 6.x [\#314](https://github.com/voxpupuli/puppet-redis/pull/314) ([alexjfisher](https://github.com/alexjfisher))
- Fix manage\_service\_file variable [\#309](https://github.com/voxpupuli/puppet-redis/pull/309) ([CallumBanbery](https://github.com/CallumBanbery))

## [v4.1.0](https://github.com/voxpupuli/puppet-redis/tree/v4.1.0) (2019-05-02)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v4.0.0...v4.1.0)

**Implemented enhancements:**

- Add service\_enable parameter to sentinel.pp [\#307](https://github.com/voxpupuli/puppet-redis/pull/307) ([rschemm-godaddy](https://github.com/rschemm-godaddy))

**Closed issues:**

- Please release v3.3.2 due to Ubuntu 18.04 / systemd fix. [\#283](https://github.com/voxpupuli/puppet-redis/issues/283)

**Merged pull requests:**

- Allow puppetlabs/apt 7.x [\#312](https://github.com/voxpupuli/puppet-redis/pull/312) ([dhoppe](https://github.com/dhoppe))

## [v4.0.0](https://github.com/voxpupuli/puppet-redis/tree/v4.0.0) (2019-03-12)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v3.3.1...v4.0.0)

This is the first release since the module was migrated to the Vox Pupuli `puppet` namespace.

**Breaking changes:**

- Support binding to all interfaces [\#302](https://github.com/voxpupuli/puppet-redis/pull/302) ([alexjfisher](https://github.com/alexjfisher))
- Drop support for puppet 3 and 4 [\#297](https://github.com/voxpupuli/puppet-redis/pull/297) ([alexjfisher](https://github.com/alexjfisher))
- Convert `redisget` to `redis::get` API v4 function [\#293](https://github.com/voxpupuli/puppet-redis/pull/293) ([alexjfisher](https://github.com/alexjfisher))

**Implemented enhancements:**

- Bind the service on all available interface [\#60](https://github.com/voxpupuli/puppet-redis/issues/60)
- Add some parameter validation using data types [\#303](https://github.com/voxpupuli/puppet-redis/pull/303) ([alexjfisher](https://github.com/alexjfisher))
- Initial rhel 8 support [\#284](https://github.com/voxpupuli/puppet-redis/pull/284) ([mbaldessari](https://github.com/mbaldessari))

**Closed issues:**

- Get acceptance tests running again [\#292](https://github.com/voxpupuli/puppet-redis/issues/292)
- Convert function to API v4 ruby function [\#291](https://github.com/voxpupuli/puppet-redis/issues/291)
- Transparent Huge Pages \(THP\) Not Disabled on RHEL [\#278](https://github.com/voxpupuli/puppet-redis/issues/278)
- Looking for maintainer \[Help needed\] [\#277](https://github.com/voxpupuli/puppet-redis/issues/277)
- Travis Credential issues... still :\( [\#267](https://github.com/voxpupuli/puppet-redis/issues/267)
- Outdated dependency puppetlabs-apt \< 3.0.0 [\#264](https://github.com/voxpupuli/puppet-redis/issues/264)
- cannot bind ipv4 and ipv6 [\#257](https://github.com/voxpupuli/puppet-redis/issues/257)
- Deprecate Puppet 3.X Support [\#152](https://github.com/voxpupuli/puppet-redis/issues/152)

**Merged pull requests:**

- Re-enable and fix acceptance tests. \(Don't manage `/var/run/redis` on Debian systems\) [\#299](https://github.com/voxpupuli/puppet-redis/pull/299) ([alexjfisher](https://github.com/alexjfisher))
-  Update metadata.json for Vox Pupuli migration [\#298](https://github.com/voxpupuli/puppet-redis/pull/298) ([alexjfisher](https://github.com/alexjfisher))
- Update `apt` and `stdlib` dependencies [\#296](https://github.com/voxpupuli/puppet-redis/pull/296) ([alexjfisher](https://github.com/alexjfisher))
- Fix github license detection [\#295](https://github.com/voxpupuli/puppet-redis/pull/295) ([alexjfisher](https://github.com/alexjfisher))
- Add badges to README [\#294](https://github.com/voxpupuli/puppet-redis/pull/294) ([alexjfisher](https://github.com/alexjfisher))
- Fix tests and initial Voxpupuli modulesync [\#290](https://github.com/voxpupuli/puppet-redis/pull/290) ([alexjfisher](https://github.com/alexjfisher))
- Lint and rubocop \(autofixes only\) [\#289](https://github.com/voxpupuli/puppet-redis/pull/289) ([alexjfisher](https://github.com/alexjfisher))

## [v3.3.1](https://github.com/voxpupuli/puppet-redis/tree/v3.3.1) (2018-09-13)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v3.3.0...v3.3.1)

**Closed issues:**

- Ulimit configuration broken for systemd [\#268](https://github.com/voxpupuli/puppet-redis/issues/268)

## [v3.3.0](https://github.com/voxpupuli/puppet-redis/tree/v3.3.0) (2018-06-19)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v3.2.0...v3.3.0)

**Closed issues:**

- output\_buffer\_limit\_pubsub and output\_buffer\_limit\_slave [\#263](https://github.com/voxpupuli/puppet-redis/issues/263)
- Can't release - Require Forge Credential Refresh [\#262](https://github.com/voxpupuli/puppet-redis/issues/262)
- Module v3.2.0 not published to forge [\#255](https://github.com/voxpupuli/puppet-redis/issues/255)
- Inconsistent sentinel\_package\_name handling on Debian [\#253](https://github.com/voxpupuli/puppet-redis/issues/253)
- No pidfile for sentinel [\#238](https://github.com/voxpupuli/puppet-redis/issues/238)
- puppet-redis requires outdated puppetlabs-apt module [\#232](https://github.com/voxpupuli/puppet-redis/issues/232)
- Can't use as slave bound to localhost [\#229](https://github.com/voxpupuli/puppet-redis/issues/229)
- \[Feature Request\] Redis::Instance - Set default unixsocket [\#226](https://github.com/voxpupuli/puppet-redis/issues/226)
- Travis Forge Password Changed [\#216](https://github.com/voxpupuli/puppet-redis/issues/216)

**Merged pull requests:**

- Adds logic for installing redid-sentinel package [\#254](https://github.com/voxpupuli/puppet-redis/pull/254) ([petems](https://github.com/petems))
- Update redis mode on wheezy [\#252](https://github.com/voxpupuli/puppet-redis/pull/252) ([petems](https://github.com/petems))
- Fix spec for sentinel [\#251](https://github.com/voxpupuli/puppet-redis/pull/251) ([petems](https://github.com/petems))
- get rid of getvar\_emptystring function [\#249](https://github.com/voxpupuli/puppet-redis/pull/249) ([vicinus](https://github.com/vicinus))
- Added log\_level to sentinel. [\#248](https://github.com/voxpupuli/puppet-redis/pull/248) ([hp197](https://github.com/hp197))
- Adds redis\_cli task [\#245](https://github.com/voxpupuli/puppet-redis/pull/245) ([petems](https://github.com/petems))
- Bump Puppet version for acceptance to 4.10.8 [\#244](https://github.com/voxpupuli/puppet-redis/pull/244) ([petems](https://github.com/petems))
- protected-mode configuration option \(Redis 3.2+\) [\#243](https://github.com/voxpupuli/puppet-redis/pull/243) ([Dan70402](https://github.com/Dan70402))
- Switch to using simp-beaker suites [\#241](https://github.com/voxpupuli/puppet-redis/pull/241) ([petems](https://github.com/petems))
- Bumped apt version dependency to version \< 5.0.0 [\#237](https://github.com/voxpupuli/puppet-redis/pull/237) ([c4m4](https://github.com/c4m4))
- Updates for EL6 [\#236](https://github.com/voxpupuli/puppet-redis/pull/236) ([petems](https://github.com/petems))
- Pin version of redis gem [\#235](https://github.com/voxpupuli/puppet-redis/pull/235) ([petems](https://github.com/petems))
- Added configuration options for client-output-buffer-limit [\#233](https://github.com/voxpupuli/puppet-redis/pull/233) ([mike-petersen](https://github.com/mike-petersen))
- Allow `slaveof` when binding to localhost [\#231](https://github.com/voxpupuli/puppet-redis/pull/231) ([joshuaspence](https://github.com/joshuaspence))
- Fix issues with missing locale for Debian box [\#224](https://github.com/voxpupuli/puppet-redis/pull/224) ([petems](https://github.com/petems))
- Instance service improvements [\#222](https://github.com/voxpupuli/puppet-redis/pull/222) ([kwevers](https://github.com/kwevers))
- Make sure the service is en/disabled per user request [\#221](https://github.com/voxpupuli/puppet-redis/pull/221) ([kwevers](https://github.com/kwevers))
- Split Redis instance socket files [\#220](https://github.com/voxpupuli/puppet-redis/pull/220) ([kwevers](https://github.com/kwevers))
- Split Redis workdir [\#219](https://github.com/voxpupuli/puppet-redis/pull/219) ([kwevers](https://github.com/kwevers))
- fix package\_ensure version on ubuntu when it is in the 3:3.2.1 format [\#218](https://github.com/voxpupuli/puppet-redis/pull/218) ([sp-joseluis-ledesma](https://github.com/sp-joseluis-ledesma))
- Split the redis instance logfiles by default [\#217](https://github.com/voxpupuli/puppet-redis/pull/217) ([kwevers](https://github.com/kwevers))
- Use package\_ensure if it specifies a version instead of the minimum\_version [\#215](https://github.com/voxpupuli/puppet-redis/pull/215) ([sp-joseluis-ledesma](https://github.com/sp-joseluis-ledesma))

## [v3.2.0](https://github.com/voxpupuli/puppet-redis/tree/v3.2.0) (2017-07-11)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v3.1.1...v3.2.0)

**Implemented enhancements:**

- Cluster Support [\#62](https://github.com/voxpupuli/puppet-redis/issues/62)

**Closed issues:**

- redis\_server\_version fact fails to parse output [\#210](https://github.com/voxpupuli/puppet-redis/issues/210)
- Support for multi-instances per host [\#113](https://github.com/voxpupuli/puppet-redis/issues/113)

**Merged pull requests:**

- updated redis systemd unit file for better use with instances [\#214](https://github.com/voxpupuli/puppet-redis/pull/214) ([bostrowski13](https://github.com/bostrowski13))
- Updates docker images for CentOS 6 and 7 [\#213](https://github.com/voxpupuli/puppet-redis/pull/213) ([petems](https://github.com/petems))
- Update EPEL module [\#212](https://github.com/voxpupuli/puppet-redis/pull/212) ([petems](https://github.com/petems))
- Refactor redisget\(\) method [\#211](https://github.com/voxpupuli/puppet-redis/pull/211) ([petems](https://github.com/petems))
- Update docs for puppet-strings [\#206](https://github.com/voxpupuli/puppet-redis/pull/206) ([petems](https://github.com/petems))
- Add redis::instance defined type [\#200](https://github.com/voxpupuli/puppet-redis/pull/200) ([petems](https://github.com/petems))
- Adding note about Puppet 3 support [\#153](https://github.com/voxpupuli/puppet-redis/pull/153) ([petems](https://github.com/petems))

## [v3.1.1](https://github.com/voxpupuli/puppet-redis/tree/v3.1.1) (2017-05-19)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v3.1.0...v3.1.1)

## [v3.1.0](https://github.com/voxpupuli/puppet-redis/tree/v3.1.0) (2017-05-19)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- Releasing v3.0.1 [\#205](https://github.com/voxpupuli/puppet-redis/issues/205)
- Please cut a release [\#201](https://github.com/voxpupuli/puppet-redis/issues/201)
- Deployment to Forge [\#185](https://github.com/voxpupuli/puppet-redis/issues/185)

**Fixed bugs:**

- Sort problem in v1.2.4 template [\#195](https://github.com/voxpupuli/puppet-redis/issues/195)

**Merged pull requests:**

- Add an optional third parameter to redisget\(\) to specify a default value [\#209](https://github.com/voxpupuli/puppet-redis/pull/209) ([petems](https://github.com/petems))
- Updates docs for puppet functions [\#208](https://github.com/voxpupuli/puppet-redis/pull/208) ([petems](https://github.com/petems))
- Add switch to manage File\[/var/run/redis\] [\#204](https://github.com/voxpupuli/puppet-redis/pull/204) ([petems](https://github.com/petems))
- Ignore selinux default context for /etc/systemd/system/redis.service.d [\#202](https://github.com/voxpupuli/puppet-redis/pull/202) ([amoralej](https://github.com/amoralej))
- Make TravisCI push to the Forge [\#191](https://github.com/voxpupuli/puppet-redis/pull/191) ([arioch](https://github.com/arioch))

## [v3.0.0](https://github.com/voxpupuli/puppet-redis/tree/v3.0.0) (2017-05-11)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.2.4...v3.0.0)

**Implemented enhancements:**

- Ubuntu 16.04 support? [\#146](https://github.com/voxpupuli/puppet-redis/issues/146)
- \[Whishlist\] Extend ulimit parameter to support limits.conf and systemd [\#130](https://github.com/voxpupuli/puppet-redis/issues/130)
- Add overcommit.pp to deal with `Can't save in background: fork: Cannot allocate memory` ?  [\#105](https://github.com/voxpupuli/puppet-redis/issues/105)

**Fixed bugs:**

- The fix for issue \#192 broke service\_managed false [\#197](https://github.com/voxpupuli/puppet-redis/issues/197)
- Ubuntu 16.04 changed sentinel config filename [\#175](https://github.com/voxpupuli/puppet-redis/issues/175)
- sentinel support broken? [\#166](https://github.com/voxpupuli/puppet-redis/issues/166)
- Ownership problem with Ubuntu redis-server [\#150](https://github.com/voxpupuli/puppet-redis/issues/150)
- Parameters not valid for older Redis in config [\#111](https://github.com/voxpupuli/puppet-redis/issues/111)

**Merged pull requests:**

- Update sort to specify key [\#199](https://github.com/voxpupuli/puppet-redis/pull/199) ([petems](https://github.com/petems))
- Adds tests for when Redis service is unmanaged [\#198](https://github.com/voxpupuli/puppet-redis/pull/198) ([petems](https://github.com/petems))
- Changing Travis back to Trusty [\#194](https://github.com/voxpupuli/puppet-redis/pull/194) ([petems](https://github.com/petems))
- Remove service notification [\#193](https://github.com/voxpupuli/puppet-redis/pull/193) ([petems](https://github.com/petems))
- Improves ulimit configuration [\#192](https://github.com/voxpupuli/puppet-redis/pull/192) ([petems](https://github.com/petems))
- Updates metadata supported versions [\#190](https://github.com/voxpupuli/puppet-redis/pull/190) ([petems](https://github.com/petems))
- Adds tests for Ubuntu 1404 and Trusty package [\#189](https://github.com/voxpupuli/puppet-redis/pull/189) ([petems](https://github.com/petems))
- Adds redis::administration class [\#188](https://github.com/voxpupuli/puppet-redis/pull/188) ([petems](https://github.com/petems))
- Adds logic for managing redis-sentinel package [\#187](https://github.com/voxpupuli/puppet-redis/pull/187) ([petems](https://github.com/petems))
- Bump to version 3.0.0 [\#186](https://github.com/voxpupuli/puppet-redis/pull/186) ([petems](https://github.com/petems))
- Moves location of redis-sentinel file [\#184](https://github.com/voxpupuli/puppet-redis/pull/184) ([petems](https://github.com/petems))
- \(testing\) Simplify command run by TravisCI [\#183](https://github.com/voxpupuli/puppet-redis/pull/183) ([ghoneycutt](https://github.com/ghoneycutt))
- Style [\#182](https://github.com/voxpupuli/puppet-redis/pull/182) ([ghoneycutt](https://github.com/ghoneycutt))
- Adds acceptance tests for the redisget\(\) function [\#181](https://github.com/voxpupuli/puppet-redis/pull/181) ([petems](https://github.com/petems))
- Add redisget\(\) [\#179](https://github.com/voxpupuli/puppet-redis/pull/179) ([ghoneycutt](https://github.com/ghoneycutt))
- Fixes ordering of Apt repos [\#178](https://github.com/voxpupuli/puppet-redis/pull/178) ([petems](https://github.com/petems))
- Add 2.4.10 config file for CentOS 6 [\#177](https://github.com/voxpupuli/puppet-redis/pull/177) ([petems](https://github.com/petems))
- Refactoring common code patterns [\#174](https://github.com/voxpupuli/puppet-redis/pull/174) ([petems](https://github.com/petems))
- Changes permission on /var/run/ directory [\#173](https://github.com/voxpupuli/puppet-redis/pull/173) ([petems](https://github.com/petems))
- Bump Beaker Ruby versions [\#172](https://github.com/voxpupuli/puppet-redis/pull/172) ([petems](https://github.com/petems))
- Fixes sentinel installation on Debian flavours [\#171](https://github.com/voxpupuli/puppet-redis/pull/171) ([petems](https://github.com/petems))
- Adds vagrant beaker images [\#170](https://github.com/voxpupuli/puppet-redis/pull/170) ([petems](https://github.com/petems))
- Adds acceptance test for master/slave testing [\#168](https://github.com/voxpupuli/puppet-redis/pull/168) ([petems](https://github.com/petems))
- Renames spec file [\#165](https://github.com/voxpupuli/puppet-redis/pull/165) ([petems](https://github.com/petems))
- Adds specific versions to fixtures [\#164](https://github.com/voxpupuli/puppet-redis/pull/164) ([petems](https://github.com/petems))
- Changes for RHEL-ish specific configuration [\#162](https://github.com/voxpupuli/puppet-redis/pull/162) ([petems](https://github.com/petems))
- Changes CentOS Docker images [\#160](https://github.com/voxpupuli/puppet-redis/pull/160) ([petems](https://github.com/petems))
- Updates fact for CentOS 6 [\#159](https://github.com/voxpupuli/puppet-redis/pull/159) ([petems](https://github.com/petems))
- Fixes lint arrow errors [\#158](https://github.com/voxpupuli/puppet-redis/pull/158) ([petems](https://github.com/petems))
- README lint [\#155](https://github.com/voxpupuli/puppet-redis/pull/155) ([matonb](https://github.com/matonb))
- Archlinux: Added tests and update config\_dir parameter [\#149](https://github.com/voxpupuli/puppet-redis/pull/149) ([bartjanssens92](https://github.com/bartjanssens92))
- Add CHANGELOG [\#148](https://github.com/voxpupuli/puppet-redis/pull/148) ([petems](https://github.com/petems))
- Added Archlinux as supported OS [\#147](https://github.com/voxpupuli/puppet-redis/pull/147) ([bartjanssens92](https://github.com/bartjanssens92))

## [1.2.4](https://github.com/voxpupuli/puppet-redis/tree/1.2.4) (2016-12-05)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.2.3...1.2.4)

**Implemented enhancements:**

- Speed up Travis [\#118](https://github.com/voxpupuli/puppet-redis/issues/118)

**Fixed bugs:**

- Wrong redis.conf after c45049986a7fcb1c9a0591de123c6bf97c761355 [\#142](https://github.com/voxpupuli/puppet-redis/issues/142)
- powerstack.org - No longer hosted [\#103](https://github.com/voxpupuli/puppet-redis/issues/103)

**Closed issues:**

- redis.conf under /etc/redis.conf [\#81](https://github.com/voxpupuli/puppet-redis/issues/81)
- Add socket option [\#79](https://github.com/voxpupuli/puppet-redis/issues/79)
- preinstall.pp fails on CEntOS 6.5 and Puppet Enterprise 2.7. [\#72](https://github.com/voxpupuli/puppet-redis/issues/72)
- How do I change from powerstack.org repo if I need to? Should I just edit manifests/preinstall.pp?  [\#68](https://github.com/voxpupuli/puppet-redis/issues/68)
- puppet-redis || every time when puppet runs, the service restarts [\#59](https://github.com/voxpupuli/puppet-redis/issues/59)
- 'manage\_repo =\> true' causes run to fail because add-apt-repository command isn't available [\#49](https://github.com/voxpupuli/puppet-redis/issues/49)

**Merged pull requests:**

- For folks that do not use redis to cache to disk [\#144](https://github.com/voxpupuli/puppet-redis/pull/144) ([petems](https://github.com/petems))
- Revert "Changes templates to use scope" [\#143](https://github.com/voxpupuli/puppet-redis/pull/143) ([petems](https://github.com/petems))
- Update sentinel.pp [\#141](https://github.com/voxpupuli/puppet-redis/pull/141) ([xprntl](https://github.com/xprntl))
- Manage workdir and permissions [\#138](https://github.com/voxpupuli/puppet-redis/pull/138) ([petems](https://github.com/petems))
- Adds minimum versions parameters [\#137](https://github.com/voxpupuli/puppet-redis/pull/137) ([petems](https://github.com/petems))
- Adds redis-server version fact [\#136](https://github.com/voxpupuli/puppet-redis/pull/136) ([petems](https://github.com/petems))
- adding /var/run/redis for Debian based hosts [\#135](https://github.com/voxpupuli/puppet-redis/pull/135) ([petems](https://github.com/petems))
- Refactor unit tests [\#134](https://github.com/voxpupuli/puppet-redis/pull/134) ([petems](https://github.com/petems))
- Update acceptance tests [\#133](https://github.com/voxpupuli/puppet-redis/pull/133) ([petems](https://github.com/petems))
- Speed up Travis even more [\#125](https://github.com/voxpupuli/puppet-redis/pull/125) ([petems](https://github.com/petems))
- Add fast finish to Travis [\#124](https://github.com/voxpupuli/puppet-redis/pull/124) ([petems](https://github.com/petems))
- Changes package installation [\#123](https://github.com/voxpupuli/puppet-redis/pull/123) ([petems](https://github.com/petems))
- Fix Beaker settings [\#122](https://github.com/voxpupuli/puppet-redis/pull/122) ([petems](https://github.com/petems))
- Fixes gpg key for DotDeb [\#121](https://github.com/voxpupuli/puppet-redis/pull/121) ([petems](https://github.com/petems))
- Sent bind address rebase [\#120](https://github.com/voxpupuli/puppet-redis/pull/120) ([petems](https://github.com/petems))
- Changes templates to use scope [\#119](https://github.com/voxpupuli/puppet-redis/pull/119) ([petems](https://github.com/petems))
- Add save interval squash [\#117](https://github.com/voxpupuli/puppet-redis/pull/117) ([petems](https://github.com/petems))
- FreeBSD fixes [\#116](https://github.com/voxpupuli/puppet-redis/pull/116) ([petems](https://github.com/petems))
- Consolidate travis and testing [\#115](https://github.com/voxpupuli/puppet-redis/pull/115) ([petems](https://github.com/petems))
- Fix specs [\#114](https://github.com/voxpupuli/puppet-redis/pull/114) ([Phil-Friderici](https://github.com/Phil-Friderici))
- Remove single quotes around variable [\#101](https://github.com/voxpupuli/puppet-redis/pull/101) ([rorybrowne](https://github.com/rorybrowne))

## [1.2.3](https://github.com/voxpupuli/puppet-redis/tree/1.2.3) (2016-09-19)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.2.2...1.2.3)

**Merged pull requests:**

- Adds spec for unixsocket and perms [\#99](https://github.com/voxpupuli/puppet-redis/pull/99) ([petems](https://github.com/petems))
- Added the ability to configure Unix socket binding [\#97](https://github.com/voxpupuli/puppet-redis/pull/97) ([gcelestine](https://github.com/gcelestine))
- Lint and English cleanup in the redis.conf [\#93](https://github.com/voxpupuli/puppet-redis/pull/93) ([ryayon](https://github.com/ryayon))
- Added more configuration options to redis.conf [\#90](https://github.com/voxpupuli/puppet-redis/pull/90) ([hanej](https://github.com/hanej))
- Make notification of service optional [\#89](https://github.com/voxpupuli/puppet-redis/pull/89) ([michaeltchapman](https://github.com/michaeltchapman))

## [1.2.2](https://github.com/voxpupuli/puppet-redis/tree/1.2.2) (2016-03-17)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.2.1...1.2.2)

**Closed issues:**

- Error 400 on SERVER: Puppet::Parser::AST::Resource failed with error ArgumentError: Invalid resource type redis [\#86](https://github.com/voxpupuli/puppet-redis/issues/86)
- Potential bug: `64min` should read `64mb` [\#73](https://github.com/voxpupuli/puppet-redis/issues/73)
- Typo on sentinel.pp on if defined [\#69](https://github.com/voxpupuli/puppet-redis/issues/69)
- Does't configure EPEL repository on CentOS 7 [\#61](https://github.com/voxpupuli/puppet-redis/issues/61)

## [1.2.1](https://github.com/voxpupuli/puppet-redis/tree/1.2.1) (2015-12-09)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.2.0...1.2.1)

**Merged pull requests:**

- Fix puppet-redis for Redis \< 3 [\#77](https://github.com/voxpupuli/puppet-redis/pull/77) ([EmilienM](https://github.com/EmilienM))

## [1.2.0](https://github.com/voxpupuli/puppet-redis/tree/1.2.0) (2015-12-03)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.1.3...1.2.0)

**Closed issues:**

- $daemonize is defaulted to 'false' on Redhat OS, which causes service command to hang [\#64](https://github.com/voxpupuli/puppet-redis/issues/64)
- Redis service start fail on Debian stable \(Wheezy 7.0\) [\#52](https://github.com/voxpupuli/puppet-redis/issues/52)

**Merged pull requests:**

- Redis Cluster 3.0 Feature [\#71](https://github.com/voxpupuli/puppet-redis/pull/71) ([claudio-walser](https://github.com/claudio-walser))
- Fix Support for EL7 and Puppet 4 [\#66](https://github.com/voxpupuli/puppet-redis/pull/66) ([trlinkin](https://github.com/trlinkin))
- Add a option to override the service provider [\#63](https://github.com/voxpupuli/puppet-redis/pull/63) ([nerzhul](https://github.com/nerzhul))
- add support for hz option [\#50](https://github.com/voxpupuli/puppet-redis/pull/50) ([nerzhul](https://github.com/nerzhul))

## [1.1.3](https://github.com/voxpupuli/puppet-redis/tree/1.1.3) (2015-08-19)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.1.2...1.1.3)

**Closed issues:**

- Unable to bring in as a dependency [\#47](https://github.com/voxpupuli/puppet-redis/issues/47)

**Merged pull requests:**

- Bump puppetlabs-stdlib version spec [\#48](https://github.com/voxpupuli/puppet-redis/pull/48) ([gblair](https://github.com/gblair))

## [1.1.2](https://github.com/voxpupuli/puppet-redis/tree/1.1.2) (2015-08-06)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.1.1...1.1.2)

**Closed issues:**

- Error on CentOS 7 when manage\_repo: true [\#44](https://github.com/voxpupuli/puppet-redis/issues/44)

## [1.1.1](https://github.com/voxpupuli/puppet-redis/tree/1.1.1) (2015-08-04)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.1.0...1.1.1)

**Closed issues:**

- Commit edd7cb55931fe0336bfee475c738ac4b91308f98 seems to be pasting undef params into redis.conf [\#41](https://github.com/voxpupuli/puppet-redis/issues/41)

**Merged pull requests:**

- Save db to disk [\#46](https://github.com/voxpupuli/puppet-redis/pull/46) ([adrian-balcan-ygt](https://github.com/adrian-balcan-ygt))
- Use puppetlabs\_spec\_helper for testing [\#45](https://github.com/voxpupuli/puppet-redis/pull/45) ([jlyheden](https://github.com/jlyheden))
- copy variables used in template to local scope [\#42](https://github.com/voxpupuli/puppet-redis/pull/42) ([eoly](https://github.com/eoly))

## [1.1.0](https://github.com/voxpupuli/puppet-redis/tree/1.1.0) (2015-06-22)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.0.7...1.1.0)

**Merged pull requests:**

- access out-of-scope variables via the scope.lookupvar method [\#40](https://github.com/voxpupuli/puppet-redis/pull/40) ([eoly](https://github.com/eoly))

## [1.0.7](https://github.com/voxpupuli/puppet-redis/tree/1.0.7) (2015-06-02)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.0.6...1.0.7)

**Fixed bugs:**

- Sentinel init/upstart file doesn't exist [\#18](https://github.com/voxpupuli/puppet-redis/issues/18)

**Closed issues:**

- Default config\_owner of redis [\#39](https://github.com/voxpupuli/puppet-redis/issues/39)
- Duplicate decleration Package\[redis\] when both include redis and redis::sentinel [\#36](https://github.com/voxpupuli/puppet-redis/issues/36)
- Does not work with Debian 7.8 with redis version 2.4.14-1 [\#24](https://github.com/voxpupuli/puppet-redis/issues/24)

**Merged pull requests:**

- Fixed duplicate declaration of package [\#38](https://github.com/voxpupuli/puppet-redis/pull/38) ([raiblue](https://github.com/raiblue))
- fix issue with params.pp with strict\_variables enabled [\#35](https://github.com/voxpupuli/puppet-redis/pull/35) ([eoly](https://github.com/eoly))
- Enable to not manage the Redis service [\#34](https://github.com/voxpupuli/puppet-redis/pull/34) ([Spredzy](https://github.com/Spredzy))
- Suse conf file fix [\#33](https://github.com/voxpupuli/puppet-redis/pull/33) ([christofhaerens](https://github.com/christofhaerens))
- added Suse osfamily [\#32](https://github.com/voxpupuli/puppet-redis/pull/32) ([christofhaerens](https://github.com/christofhaerens))

## [1.0.6](https://github.com/voxpupuli/puppet-redis/tree/1.0.6) (2015-05-05)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.0.5...1.0.6)

## [1.0.5](https://github.com/voxpupuli/puppet-redis/tree/1.0.5) (2015-03-30)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.0.4...1.0.5)

## [1.0.4](https://github.com/voxpupuli/puppet-redis/tree/1.0.4) (2015-01-19)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.0.3...1.0.4)

## [1.0.3](https://github.com/voxpupuli/puppet-redis/tree/1.0.3) (2015-01-05)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.0.2...1.0.3)

**Implemented enhancements:**

- Feature Request: support for redis-sentinel [\#13](https://github.com/voxpupuli/puppet-redis/issues/13)

## [1.0.2](https://github.com/voxpupuli/puppet-redis/tree/1.0.2) (2014-12-17)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.0.1...1.0.2)

## [1.0.1](https://github.com/voxpupuli/puppet-redis/tree/1.0.1) (2014-10-22)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/1.0.0...1.0.1)

## [1.0.0](https://github.com/voxpupuli/puppet-redis/tree/1.0.0) (2014-10-22)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/0.0.10...1.0.0)

## [0.0.10](https://github.com/voxpupuli/puppet-redis/tree/0.0.10) (2014-08-29)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/0.0.9...0.0.10)

## [0.0.9](https://github.com/voxpupuli/puppet-redis/tree/0.0.9) (2014-08-29)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/0.0.8...0.0.9)

**Closed issues:**

- Amazon AMI Installation/Initialization Issue [\#11](https://github.com/voxpupuli/puppet-redis/issues/11)

## [0.0.8](https://github.com/voxpupuli/puppet-redis/tree/0.0.8) (2014-03-27)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/0.0.7...0.0.8)

**Closed issues:**

- Default bind on public interface [\#6](https://github.com/voxpupuli/puppet-redis/issues/6)
- Install a specific version [\#4](https://github.com/voxpupuli/puppet-redis/issues/4)

## [0.0.7](https://github.com/voxpupuli/puppet-redis/tree/0.0.7) (2014-01-13)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/0.0.6...0.0.7)

## [0.0.6](https://github.com/voxpupuli/puppet-redis/tree/0.0.6) (2013-08-07)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/0.0.5...0.0.6)

**Merged pull requests:**

- add ubuntu ppa repo support [\#3](https://github.com/voxpupuli/puppet-redis/pull/3) ([nagas](https://github.com/nagas))

## [0.0.5](https://github.com/voxpupuli/puppet-redis/tree/0.0.5) (2013-07-22)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/0.0.4...0.0.5)

**Closed issues:**

- Redis config 2.6 not compatible with EPELs 2.4 on Centos6 [\#2](https://github.com/voxpupuli/puppet-redis/issues/2)

## [0.0.4](https://github.com/voxpupuli/puppet-redis/tree/0.0.4) (2013-07-17)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/0.0.3...0.0.4)

**Closed issues:**

- Default config path wrong for RedHat [\#1](https://github.com/voxpupuli/puppet-redis/issues/1)

## [0.0.3](https://github.com/voxpupuli/puppet-redis/tree/0.0.3) (2013-07-08)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/0.0.2...0.0.3)

## [0.0.2](https://github.com/voxpupuli/puppet-redis/tree/0.0.2) (2013-06-19)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/0.0.1...0.0.2)

## [0.0.1](https://github.com/voxpupuli/puppet-redis/tree/0.0.1) (2013-06-19)

[Full Changelog](https://github.com/voxpupuli/puppet-redis/compare/9eeef29abac112e9f44aa2d2c0ed6ea1f2617888...0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
