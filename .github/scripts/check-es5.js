#!/usr/bin/env node
/**
 * ES5 compliance checker for core HTML files (dock.html, overlay.html).
 * These files must use ES5-only JavaScript for OBS CEF compatibility.
 *
 * Checks: const/let declarations, template literals, arrow functions.
 * Extracts only <script> block content and strips JS comments to avoid
 * false positives from CSS comments or string content.
 */
'use strict';

var fs = require('fs');
var path = require('path');

var FILES = ['dock.html', 'overlay.html'];
var failed = 0;

function extractScriptBlocks(html) {
  var blocks = [];
  var lines = html.split('\n');
  var inScript = false;
  var startLine = 0;

  for (var i = 0; i < lines.length; i++) {
    var line = lines[i];
    if (!inScript && /<script[\s>]/i.test(line)) {
      inScript = true;
      startLine = i + 1; // 1-based
      continue;
    }
    if (inScript && /<\/script>/i.test(line)) {
      inScript = false;
      continue;
    }
    if (inScript) {
      blocks.push({ text: line, lineNum: i + 1 });
    }
  }
  return blocks;
}

function stripComments(lines) {
  var result = [];
  var inBlock = false;

  for (var i = 0; i < lines.length; i++) {
    var text = lines[i].text;
    var lineNum = lines[i].lineNum;
    var cleaned = '';

    if (inBlock) {
      var endIdx = text.indexOf('*/');
      if (endIdx === -1) {
        // Entire line is inside block comment
        result.push({ text: '', lineNum: lineNum });
        continue;
      }
      text = text.substring(endIdx + 2);
      inBlock = false;
    }

    // Process remaining text character by character
    var j = 0;
    while (j < text.length) {
      // Skip string literals
      if (text[j] === '"' || text[j] === "'") {
        var quote = text[j];
        cleaned += text[j];
        j++;
        while (j < text.length && text[j] !== quote) {
          if (text[j] === '\\') { cleaned += text[j]; j++; }
          if (j < text.length) { cleaned += text[j]; j++; }
        }
        if (j < text.length) { cleaned += text[j]; j++; }
        continue;
      }
      // Block comment start
      if (text[j] === '/' && j + 1 < text.length && text[j + 1] === '*') {
        var endIdx2 = text.indexOf('*/', j + 2);
        if (endIdx2 === -1) {
          inBlock = true;
          break;
        }
        j = endIdx2 + 2;
        continue;
      }
      // Line comment
      if (text[j] === '/' && j + 1 < text.length && text[j + 1] === '/') {
        break;
      }
      cleaned += text[j];
      j++;
    }

    result.push({ text: cleaned, lineNum: lineNum });
  }
  return result;
}

function checkFile(filePath) {
  if (!fs.existsSync(filePath)) {
    console.log('SKIP: ' + filePath + ' not found');
    return 0;
  }

  var html = fs.readFileSync(filePath, 'utf8');
  var scriptLines = extractScriptBlocks(html);
  var cleaned = stripComments(scriptLines);
  var errors = 0;
  var warnings = 0;
  var name = path.basename(filePath);

  for (var i = 0; i < cleaned.length; i++) {
    var text = cleaned[i].text;
    var lineNum = cleaned[i].lineNum;

    // const/let declarations
    if (/^\s*(const|let)\s/.test(text)) {
      console.log('  ' + name + ':' + lineNum + ': ' + text.trim());
      errors++;
    }

    // Template literals with interpolation
    if (/`[^`]*\$\{/.test(text)) {
      console.log('  ' + name + ':' + lineNum + ': ' + text.trim());
      errors++;
    }

    // Arrow functions (exclude >=, <=, !==, ===)
    if (/[^=!<>]=>/.test(text)) {
      console.log('  WARNING ' + name + ':' + lineNum + ': possible arrow function: ' + text.trim());
      warnings++;
    }
  }

  if (errors > 0) {
    console.log('FAIL: ES6+ syntax found in ' + name + ' (' + errors + ' violation(s))');
  } else {
    console.log('  OK: ' + name);
  }

  return errors;
}

console.log('=== ES5 compliance check for core files ===');

for (var i = 0; i < FILES.length; i++) {
  failed += checkFile(FILES[i]);
}

if (failed === 0) {
  console.log('All core files ES5 compliant');
}

process.exit(failed > 0 ? 1 : 0);
