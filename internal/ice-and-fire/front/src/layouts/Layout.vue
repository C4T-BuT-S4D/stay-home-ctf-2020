<template>
    <div>
        <b-container fluid="md">
            <b-row class="p-4" align-h="center">
                <div class="b-col col-10 col-lg-8">
                    <b-jumbotron>
                        <template v-slot:header
                            ><div class="text-center">Ice and Fire</div>
                        </template>
                        <slot />
                    </b-jumbotron>
                </div>
            </b-row>
        </b-container>
    </div>
</template>

<script>
export default {};
</script>
