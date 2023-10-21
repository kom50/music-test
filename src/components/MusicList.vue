<template>
  <div class="w-full bg-white">
    <div class="w-full x-auto max-w-2xl px-4 py-16 sm:px-6 sm:py-24 lg:max-w-7xl lg:px-8">
      <h4 class="text-2xl text-center my-5">{{ isLoading ? 'Please wait' : 'Music loaded' }}</h4>

      <div class="w-full grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 xl:gap-x-8">

        <input type="file" @input="getFiles" @ended="nextAudio" multiple>

        <audio src="#" ref="audio"></audio>
        <br>
        <div class="flex justify-around">
          <button @click="previous" title="Previous">
            <span class="material-icons"> skip_previous </span>
          </button>
          <button @click="play" ref="playBtn" :title="!isPlaying ? 'Play' : 'Pause'">
            <span class="material-icons"> {{ !isPlaying ? 'play_arrow' : 'pause' }}</span>
          </button>
          <button @click="next" title="Next">
            <span class="material-icons"> skip_next </span>
          </button>
        </div>
        <br>
        <div class="flex justify-between">
          <button @click="shuffle" title="Shuffle">
            <span class="material-icons"> {{ !isShuffle ? 'shuffle' : 'shuffle_on' }} </span>
          </button>
          <button @click="repeat" title="Repeat">
            <span class="material-icons"> {{ !isRepeat ? 'repeat' : 'repeat_on' }} </span>
          </button>
        </div>

      </div>
      <!-- For audio progress bar controlls -->
      <div class="flex flex-col justify-center items-center w-full ">
        <!-- progress bar timeline -->
        <div class="w-full flex justify-between">
          <div ref="start">00:00</div>
          <div ref="end">10:10</div>
        </div>
        <div class="flex w-full">
          <input ref="progressBar" v-model='progress' type="range" @input="changeTrack"
            class="w-full h-1 mb-6 bg-gray-200 rounded-lg appearance-none cursor-pointer range-sm dark:bg-gray-700">
        </div>
      </div>
      <!-- For volume controlls -->
      <div>
        <br>
        Change volume
        <div class="flex justify-center items-center w-full">
          <input v-model='volume' type="range" @input="changeVolume" step="10"
            class="w-full h-1 mb-6 bg-gray-200 rounded-lg appearance-none cursor-pointer range-sm dark:bg-gray-700">
        </div>
      </div>
    </div>
  </div>
</template>


<script setup>
import { onMounted, ref } from 'vue';

const audioFiles = ref([])
const audio = ref(null)
// const playBtn = ref(null)
const isPlaying = ref(false)
const isLoading = ref(true)
const isShuffle = ref(false)

const progressBar = ref(null)
const progress = ref(0)
const volume = ref(100) // cal - ((100 / 100) / 1) = 1

const start = ref(null)
const end = ref(null)

const currentAudioIndex = ref(0)
const isRepeat = ref(false)

async function readFile(url) {
  const res = await fetch(url)
  return await res.blob()
}

const songsList = [
  'SoundHelix-Song-10.mp3',
  'SoundHelix-Song-5.mp3',
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

  // if (!audio.value) reutrn

  // playBtn.value.textContent = isPlaying.value ? 'Play' : 'Pause'

  audio.value[!isPlaying.value ? 'play' : 'pause']()
  isPlaying.value = !isPlaying.value
}


function next() {
  if (audioFiles.value.length - 1 !== currentAudioIndex.value)
    currentAudioIndex.value++
  else currentAudioIndex.value = 0

  audio.value.src = audioFiles.value[currentAudioIndex.value]
  audio.value.play()
}


function previous() {
  if (currentAudioIndex.value === 0)
    currentAudioIndex.value = audioFiles.value.length - 1
  else currentAudioIndex.value--

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
  isRepeat.value = !isRepeat.value
}

/** 
 * Function to change audio track manually 
 */
function changeTrack() {
  const per = progress.value / 100
  audio.value.currentTime = (audio.value.duration || 0) * per
}

/**
 * Function to controll volume 
 */
function changeVolume() {
  const value = (volume.value / 100) / 1
  audio.value.volume = value
}
/**
 * Function to return formatted timestamp 
 * 
 * @param {number} timestamp- timestamp in seconds
 * @returns {string} - formatted timestamp
 * 
 * @example like 00:10, 04:46
 */
function formattedDuration(timestamp) {
  return new Date(timestamp * 1000).toISOString().substr(14, 5);
}

onMounted(() => {
  // Audio data loaded
  audio.value.addEventListener('loadeddata', (event) => {
    progressBar.value.value = 0

    end.value.textContent = formattedDuration(event.target.duration)
  })

  // audio ended
  audio.value.addEventListener('ended', () => {
    console.log('music ended')
    if (isRepeat.value) audio.value.play()
    else if (!isShuffle.value) next()
    else shuffle()
  })

  console.log("🚀 ~ audio ", audio.value)

  // progress bar time update
  audio.value.addEventListener('timeupdate', (event) => {
    progress.value = (event.target.currentTime / event.target.duration) * 100

    // Update timeline
    start.value.textContent = formattedDuration(event.target.currentTime)
  })
})
</script>