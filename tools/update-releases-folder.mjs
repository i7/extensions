#!/usr/bin/env node
// Update releases folder with extensions that are tagged with their supported releases

import fs from 'fs/promises'
import fs_sync from 'fs'
import path from 'path'

const RELEASE_TAG = /\[\s*Supported\s+releases\s*:([\w, ]+)\]/i
const RELEASES_FOLDER = 'releases'
const SUPPORTED_FILES = /\.(i6t|i7x)$/i
const SUPPORTED_RELEASES = [
    '6G60',
    '6L02',
    '6L38',
    '6M62',
    '10.1',
]

const folders = (await fs.readdir('.'))
    .filter(path => fs_sync.statSync(path).isDirectory())

for (const author of folders) {
    const files = (await fs.readdir(author))
        .map(filename => path.join(author, filename))
        .filter(path => fs_sync.statSync(path).isFile())
        .filter(path => SUPPORTED_FILES.test(path))

    for (const file_path of files) {
        const file_contents = await fs.readFile(file_path, 'utf8')
        const supported_releases_match = RELEASE_TAG.exec(file_contents)
        if (!supported_releases_match) {
            continue
        }

        const support_releases = supported_releases_match[1].split(',')
            .map(release => release.trim())
            .filter(release => SUPPORTED_RELEASES.includes(release))

        for (const release of support_releases) {
            const dest_path = path.join(RELEASES_FOLDER, release, file_path)
            await fs.mkdir(path.dirname(dest_path), {recursive: true})
            await fs.writeFile(dest_path, file_contents)
        }
    }
}