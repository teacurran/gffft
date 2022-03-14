# gffft

steps to get started:

1. install flutter Sdk: https://docs.flutter.dev/get-started/install/macos
2. flutter run -d macos

This default configuration should authenticate and connect to an API running
in the cloud.

## to run against local back-end:
1. run backend app from gffft-backend project
2. get your local IP address.
  * on osx using ifconfig, it's the 4 numbers after inet
  * '192.168.0.199' in the below example

```
> ifconfig

en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
        options=400<CHANNEL_IO>
        ether 14:7d:da:d6:3f:73
        inet6 fe80::10e7:b5f2:272a:5adc%en0 prefixlen 64 secured scopeid 0x6
        inet 192.168.0.199 netmask 0xffffff00 broadcast 192.168.0.255
```

3. using `.env.sample`, paste into the file `.env` and edit to use your IP address.
  * `127.0.0.1` will not work

4. tell git to not commit the changes you just made to `.env`:
```
git update-index –-assume-unchanged .env
```

5. run the app same as before:
```
flutter run -d macos
```



## other stuff

## Json Serialization
* model classes are annotated with @JsonSerializable and toJson()/fromJson() stubbed out

to run the generation:
```
flutter packages pub run build_runner build --delete-conflicting-outputs
```



with a watcher:
```
flutter pub run build_runner watch
```
