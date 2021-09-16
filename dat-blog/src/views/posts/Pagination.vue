<template>
  <div>
    <hr />
    <div class="columns">
      <div class="column is-3"></div>
      <div class="column is-6">
        <section>
          <b-pagination
            :total="totalPages"
            v-model="currentPage"
            :range-before="rangeBefore"
            :range-after="rangeAfter"
            :order="order"
            :per-page="perPage"
            aria-next-label="Next page"
            aria-previous-label="Previous page"
            aria-page-label="Page"
            aria-current-label="Current page"
            @change="submitData"
          >
          </b-pagination>
        </section>
      </div>
      <div class="column is-3"></div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Pagination",
  props: {
    totalPages: Number,
    perPage: Number,
    current: Number
  },
  data() {
    return {
      currentPage: this.current || 1,
      rangeBefore: 3,
      rangeAfter: 1,
      order: "is-centered",
    };
  },
  methods: {
    submitData() {
      this.$emit('current-page', this.currentPage)
    }
  }
};
</script>
