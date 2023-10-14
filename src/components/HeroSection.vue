<!-- This example requires Tailwind CSS v2.0+ -->
<template>
  <div class="relative bg-gray-50 overflow-hidden">
    <div class="hidden sm:block sm:absolute sm:inset-y-0 sm:h-full sm:w-full" aria-hidden="true">
      <div class="relative h-full max-w-7xl mx-auto">

      </div>
    </div>

    <div class="relative pt-6 pb-16 sm:pb-24">
      <main class="mt-16 mx-auto max-w-7xl px-4 sm:mt-24">
        <div class="text-center">
          <h1 class="text-4xl tracking-tight font-extrabold text-gray-900 sm:text-5xl md:text-6xl">
            {{ ' ' }}
            <span class="block text-indigo-600 xl:inline">Online music</span>
          </h1>
          <div class="mt-5 max-w-md mx-auto sm:flex sm:justify-center md:mt-8">

          </div>
        </div>
      </main>
    </div>
  </div>
</template>
  
<script setup>
import { Popover, PopoverButton, PopoverPanel } from '@headlessui/vue'

const navigation = [
  { name: 'Product', href: '#' },
  { name: 'Features', href: '#' },
  { name: 'Marketplace', href: '#' },
  { name: 'Company', href: '#' },
]

</script>