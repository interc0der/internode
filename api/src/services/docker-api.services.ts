import { Request, Response, NextFunction } from 'express';
import util from 'util';
import * as child_process from 'child_process';
import { formatNetworksAndContainers } from '../helpers/formatNetworksAndContainers';
import { formatRawContainers } from '../helpers/formatRawContainers';

// make the terminal commands return normal thenable promises
const exec = util.promisify(child_process.exec);

const getNetworks = async () => {
        // this version of the docker API returns networks and associated containers
        // Docker's API is backwards compatible with older versions
        const { stdout, stderr } = await exec(
          'curl --unix-socket /var/run/docker.sock http://localhost/v1.41/networks'
        );
    
        if (!stdout) return
        return JSON.parse(stdout);
}

const getContainers = async () => {
    const { stdout, stderr } = await exec(
      'curl --unix-socket /var/run/docker.sock http://localhost/v1.41/containers/json '
    );

    if (!stdout) return
    return JSON.parse(stdout);
}

const getImages = async () => {
    const { stdout, stderr } = await exec(
      'curl --unix-socket /var/run/docker.sock http://localhost/v1.41/images/json '
    );

    if (!stdout) return
    return JSON.parse(stdout);
}

const getVolumes = async () => {
    const { stdout, stderr } = await exec(
      'curl --unix-socket /var/run/docker.sock http://localhost/v1.41/volumes '
    );

    if (!stdout) return
    return JSON.parse(stdout);
}

const getEvents = async () => {
    const { stdout, stderr } = await exec(
      'curl --unix-socket /var/run/docker.sock http://localhost/v1.41/events'
    );

    if (!stdout) return
    return JSON.parse(stdout);
}


const main = async () => {
    let response = await getNetworks()
    console.log(response)
}

main()
