<template>
  <div class="bg-white">
    <div class="mx-auto max-w-2xl px-4 py-16 sm:px-6 sm:py-24 lg:max-w-7xl lg:px-8">
      <h2 class="sr-only">Products</h2>

      <div class="grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 xl:gap-x-8">
        <input type="file" @input="getFiles" multiple>
        <!-- More products... -->

        <audio src="#" ref="audio"></audio>

        <button @click="play">PLay</button>
      </div>
    </div>
  </div>
</template>


<script setup>
import { ref } from 'vue';


const audioFiles = ref([])
const audio = ref(null)

function getFiles(event) {

  const files = event.target.files

  for (let i = 0; i < files.length; i++) {
    audioFiles.value[i] = URL.createObjectURL(files[i]);
    console.log("🚀 ~ file: MusicList.vue:32 ~ getFiles ~ audioFiles:", audioFiles.value)
  }

  // audioFiles.value[0].play()
  // audioFiles.value[0].play()

  audio.value.src = audioFiles.value[0]
  audio.value.play()

}


function play() {

}

</script>