<template>
    <div class="w-full h-full bg-gray-200 flex justify-center items-center px-1 box-border">
        <div class="bg-gradient-to-t from-gray-100 to-pink-200 sm:w-96 w-full sm:h-4/5 h-[100%] rounded-lg bottom-0">
            <div class="h-full w-full relative">
                <!-- music list -->
                <div class="h-[85%] w-full bg-white absolute left-0 bottom-0 z-20 shadow-xl sm:rounded-lg rounded-tr-3xl rounded-tl-3xl transition-all delay-100 px-2"
                    v-if="isListShowing">
                    <!-- top navigation  -->
                    <div class="flex justify-between items-center  w-full border-b-2 h-22 mt-2 ">
                        <button @click="() => isListShowing = false"
                            class="w-12 h-12 rounded-full flex justify-center items-center">
                            <span class="material-icons text-gray-400"> close </span>
                        </button>
                        <h3 class="text-xl font-bold text-center -ml-14">Play list</h3>
                        <h3 class="text-xl none"> </h3>
                    </div>
                    <!-- music list -->
                    <div class="h-full">
                        <div v-for="(song, index) in songsList" :key="song" @click="changeMusic(index)">
                            <div class="flex justify-start items-center mt-3 w-full border-gray-100 border-b-[1px] p-2">
                                <!-- <div class="w-14 h-14 bg-blue-400 rounded-lg"> </div> -->
                                <button v-if="index === currentAudioIndex">
                                    <span class="material-icons text-pink-500 mt-2 pr-2"> {{ 'volume_up' }} </span>
                                </button>
                                <p class="text-ellipsis overflow-hidden"
                                    :class="[index === currentAudioIndex ? 'text-pink-700' : '']">
                                    {{ song }}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="h-full w-full relative">
                    <!-- Top section -->
                    <div class="h-[55%] w-full flex flex-col justify-center items-center">
                        <!-- top buttons -->
                        <div class="">
                            <p class="sm:-mt-[65px] -mt-6 ">My music player</p>
                            <button @click="() => isListShowing = true"
                                class="absolute top-1 left-1 w-16 h-16 rounded-full flex justify-center items-center">
                                <span class="material-icons text-gray-500 text-2xl text-[32px]">
                                    {{ 'playlist_play' }}
                                </span>
                            </button>
                        </div>
                        <!-- Image -->
                        <div class="mt-10 w-52 h-52 bg-pink-300 shadow-lg rounded-lg">
                            <div :class="[isPlaying ? 'animate-bounce' : '']">
                                <img src="../../public/music2.png" class="grayscale-0" alt="music.png">
                            </div>
                        </div>
                    </div>
                    <!-- Bottom section-->
                    <div class="botton-section  h-[45%] px-2 box-content gap-y-10 flex flex-col">
                        <!-- music-title and music track -->
                        <div class="flex flex-col gap-y-8">
                            <!-- music title -->
                            <div class="text-center text-lg overflow-hidden truncate w-full">
                                {{ songsList[currentAudioIndex] }}
                            </div>
                            <!-- Music track -->
                            <div class="">
                                <!-- progress bar timeline -->
                                <div class="flex flex-col justify-center items-center w-full ">
                                    <div class="w-full flex justify-between">
                                        <div ref="start">00:00</div>
                                        <div ref="end">00:00</div>
                                    </div>
                                    <div class="flex w-full mt-2">
                                        <input ref="progressBar" v-model='progress' type="range" @input="changeTrack"
                                            class="w-full h-1 mb-6  rounded-lg -mt-1 accent-pink-400 range-sm outline-none">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Button controlls -->
                        <div class="flex flex-col justify-center items-stretch w-full h-24 gap-y-10">
                            <div class="flex justify-around items-baseline">
                                <button @click="shuffle" title="Shuffle">
                                    <span
                                        :class="[isShuffle ? 'text-pink-500' : 'text-gray-500', 'material-icons font-medium']">
                                        {{ 'shuffle' }} </span>
                                </button>
                                <button @click="previous" title="Previous"
                                    class="bg-gray-300 w-12 h-12 rounded-full flex justify-center items-center">
                                    <span class="material-icons"> skip_previous </span>
                                </button>
                                <button @click="play"
                                    class="bg-pink-300 w-16 h-16 rounded-full flex justify-center items-center">
                                    <span class="material-icons text-white text-2xl text-[32px]">
                                        {{ !isPlaying ? 'play_arrow' : 'pause' }}
                                    </span>
                                </button>
                                <button @click="next" title="Next"
                                    class="bg-gray-300 w-12 h-12 rounded-full flex justify-center items-center">
                                    <span class="material-icons"> skip_next </span>
                                </button>
                                <button @click="repeat" title="Shuffle">
                                    <span
                                        :class="[isRepeat ? 'text-pink-500' : 'text-gray-500', 'material-icons font-medium']">
                                        {{ 'repeat' }} </span>
                                </button>
                            </div>
                            <div class="flex  justify-center items-center w-full gap-x-3">
                                <button @click="shuffle" title="Shuffle">
                                    <span :class="['material-icons font-medium text-pink-500 ']">
                                        {{ volume === '0' ? 'volume_off' : 'volume_down' }}
                                    </span>
                                </button>
                                <input v-model='volume' type="range" @input="changeVolume" step="10"
                                    class="w-full h-1 bg-gray-200 rounded-lg -mt-1 accent-pink-400">
                                <button @click="shuffle" title="Shuffle">
                                    <span class="material-icons text-pink-500 font-medium"> {{ 'volume_up' }} </span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
  
  
<script setup>
import { onMounted, ref } from 'vue';

const audioFiles = ref([])
const audio = ref(new Audio())

const isListShowing = ref(false)
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
    'Main Nikla Gaddi Leke Gadar Ek Prem Katha 128 Kbps.mp3',
    'O Bangla Gaadi Jhumke Kangana Chhupa Rustam 128 Kbps.mp3',
    'Tu Nikla Chhupa Rustam Alka Yagnik 128 Kbps.mp3',
    'Udja Kale Kawan Gadar Ek Prem Katha 128 Kbps.mp3',
    'Gadar Ror Dj Remix(MixJio.In).mp3',
    'Yeh Chand Koi Deewana Hai Chhupa Rustam 128 Kbps.mp3'

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
}

function play() {
    if (!audio.value) reutrn
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
    audio.value.volume = (volume.value / 100) / 1
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

function changeMusic(index) {
    currentAudioIndex.value = index
    audio.value.src = audioFiles.value[index]
    audio.value.play()
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
        if (event.target.duration) progress.value = (event.target.currentTime / event.target.duration) * 100

        // Update timeline
        start.value.textContent = formattedDuration(event.target.currentTime)
    })
})

</script>




<style>
input[type="range"] {
    border-radius: 8px;
    height: 4px;
    outline: none;
    /* -webkit-appearance: none; */

}
</style>