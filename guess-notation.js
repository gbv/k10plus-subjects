#!/usr/bin/env node
const jskos = require("jskos-tools")
const schemes = require("./vocabularies.json")
const readline = require("readline")
const events = require('events')

function guessNotation(notation) {
  var found = jskos.guessSchemeFromNotation(notation, schemes)
  found = found.map(s=>s.VOC)
  if (found.length) {
    console.log([notation,...found].join("\t"))
  }
}

const args = process.argv.slice(2)
if (args.length > 0) {
  for (let notation of args) {
    guessNotation(notation)
  }
} else {
  (async function processLineByLine() {
    try {
      const rl = readline.createInterface({ input: process.stdin, crlfDelay: Infinity })
      rl.on('line', (line) => {
        line=line.replace(/^\s+|\s+$/g, "")
        guessNotation(line)
      })
      await events.once(rl, 'close')
    } catch (err) {
      console.error(err)
    }
  })()
}

