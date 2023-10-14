<template>
  <div class="bg-white">
    <div class="mx-auto max-w-2xl px-4 py-16 sm:px-6 sm:py-24 lg:max-w-7xl lg:px-8">
      <h4 class="text-2xl text-center my-5">{{ isLoading ? 'Please wait' : 'Music loaded' }}</h4>

      <div class="grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 xl:gap-x-8">

        <input type="file" @input="getFiles" @ended="nextAudio" multiple>
        <audio src="#" ref="audio"></audio>

        <button @click="play" ref="playBtn">Pause</button>
        <button @click="previous">previous</button>
        <button @click="next">Next</button>
        <button @click="shuffle">Shuffle</button>
        <button @click="repeat">Repeat</button>
      </div>
    </div>
  </div>
</template>


<script setup>
import { onMounted, ref } from 'vue';

const audioFiles = ref([])
const audio = ref(null)
const playBtn = ref(null)
const isPlaying = ref(false)
const isLoading = ref(true)
const isShuffle = ref(false)

const currentAudioIndex = ref(0)

async function readFile(url) {
  const res = await fetch(url)
  return await res.blob()
}

const songsList = [
  'Bagalwali Jaan Maareli-BiharMasti.IN.mp3',
  'Hihi Hihi Has Dele Rinkiya Ke Papa-BiharMasti.IN.mp3',
  'Hum Hi Hain Bhojpuriya Don-BiharMasti.IN.mp3'
]

async function readMusic() {
  for (let i = 0; i < songsList.length; i++) {
    const musicDir = import.meta.env.MODE !== 'production' ? '/music/' : `${import.meta.env.BASE_URL}/music/`;

    const data = await readFile(musicDir + songsList[i])
    let blobUrl = URL.createObjectURL(data)

    audioFiles.value.push(blobUrl)
    audio.value.src = audioFiles.value[0]
  }
  isLoading.value = false
}

// Initially load all music files
readMusic()

function getFiles(event) {

  const files = event.target.files

  for (let i = 0; i < files.length; i++) {
    audioFiles.value[i] = URL.createObjectURL(files[i]);
  }

  audio.value.src = audioFiles.value[0]
  // audio.value.play() // stop

}


function play() {
  console.log("🚀 ~ file: MusicList.vue:50 ~ play ~ console:")

  // if (!audio.value) reutrn

  playBtn.value.textContent = isPlaying.value ? 'Play' : 'Pause'

  audio.value[!isPlaying.value ? 'play' : 'pause']()
  isPlaying.value = !isPlaying.value
}


function next() {
  if (audioFiles.value.length - 1 !== currentAudioIndex.value)
    currentAudioIndex.value++
  else
    currentAudioIndex.value = 0

  audio.value.src = audioFiles.value[currentAudioIndex.value]
  audio.value.play()
}


function previous() {
  if (currentAudioIndex.value === 0)
    currentAudioIndex.value = audioFiles.value.length - 1
  else
    currentAudioIndex.value--

  audio.value.src = audioFiles.value[currentAudioIndex.value]
  audio.value.play()
}


function shuffle() {
  const rnd = Math.floor(Math.random() * (audioFiles.length || 3))

  isShuffle.value = !isShuffle.value
  audio.value.src = audioFiles.value[rnd]
  audio.value.play()
}

function repeat() {
  // write code 
}

onMounted(() => {
  // audio ended
  audio.value.addEventListener('ended', () => {
    console.log('music ended')

    if (!isShuffle.value) next()
    else {
      shuffle()
    }

  })
})
</script>