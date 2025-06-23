import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "editButton", "saveButton", "cancelButton", "statusSelect", "techStacksSelect"]

  connect() {
    this.setupEventListeners()
  }

  setupEventListeners() {
    // Edit row functionality
    this.element.addEventListener('click', (e) => {
      if (e.target.classList.contains('edit-row')) {
        this.editRow(e.target.closest('tr'))
      } else if (e.target.classList.contains('save-row')) {
        this.saveRow(e.target.closest('tr'))
      } else if (e.target.classList.contains('cancel-row')) {
        this.cancelRow(e.target.closest('tr'))
      }
    })

    // Status select change
    this.element.addEventListener('change', (e) => {
      if (e.target.classList.contains('status-select')) {
        if (e.target.value === '__new__') {
          this.showNewStatusModal()
        }
      } else if (e.target.classList.contains('tech-stacks-select')) {
        if (e.target.value === '__new__') {
          this.showNewTechStackModal()
        }
      }
    })

    // Modal event listeners
    this.setupModalListeners()
  }

  editRow(row) {
    const appId = row.dataset.id
    
    // Show edit mode
    row.querySelector('.edit-row').classList.add('hidden')
    row.querySelector('.save-row').classList.remove('hidden')
    row.querySelector('.cancel-row').classList.remove('hidden')
    
    // Show dropdowns
    row.querySelector('.status-display').classList.add('hidden')
    row.querySelector('.status-select').classList.remove('hidden')
    
    row.querySelector('.tech-stacks-display').classList.add('hidden')
    row.querySelector('.tech-stacks-select').classList.remove('hidden')
    
    // Store original values for cancel
    row.querySelector('.status-select').value = row.querySelector('.status-select').value
    row.querySelector('.tech-stacks-select').value = row.querySelector('.tech-stacks-select').value
  }

  saveRow(row) {
    const appId = row.dataset.id
    const statusId = row.querySelector('.status-select').value
    const techStacks = Array.from(row.querySelector('.tech-stacks-select').selectedOptions)
      .filter(opt => opt.value !== '__new__')
      .map(opt => opt.value)
      .join(', ')

    // Get CSRF token
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') ||
                     document.querySelector('[name="csrf-token"]')?.content

    if (!csrfToken) {
      alert('CSRF token not found. Please refresh the page and try again.')
      return
    }

    // Send AJAX request to update
    fetch(`/job_applications/${appId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
        'Accept': 'application/json'
      },
      body: JSON.stringify({
        job_application: {
          application_status_id: statusId,
          tech_stack_names: techStacks
        }
      })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.json()
    })
    .then(data => {
      if (data.success) {
        this.exitEditMode(row)
        // Reload page to show updated data
        window.location.reload()
      } else {
        alert('Error updating application: ' + (data.error || 'Unknown error'))
      }
    })
    .catch(error => {
      console.error('Error:', error)
      alert('Error updating application: ' + error.message)
    })
  }

  cancelRow(row) {
    this.exitEditMode(row)
  }

  exitEditMode(row) {
    // Hide edit mode
    row.querySelector('.edit-row').classList.remove('hidden')
    row.querySelector('.save-row').classList.add('hidden')
    row.querySelector('.cancel-row').classList.add('hidden')
    
    // Hide dropdowns
    row.querySelector('.status-display').classList.remove('hidden')
    row.querySelector('.status-select').classList.add('hidden')
    
    row.querySelector('.tech-stacks-display').classList.remove('hidden')
    row.querySelector('.tech-stacks-select').classList.add('hidden')
  }

  showNewStatusModal() {
    document.getElementById('new-status-modal').classList.remove('hidden')
    document.getElementById('new-status-name').focus()
  }

  showNewTechStackModal() {
    document.getElementById('new-tech-stack-modal').classList.remove('hidden')
    document.getElementById('new-tech-stack-name').focus()
  }

  setupModalListeners() {
    // New status modal
    document.getElementById('save-new-status').addEventListener('click', () => {
      const name = document.getElementById('new-status-name').value.trim()
      if (name) {
        this.createNewStatus(name)
      }
    })

    document.getElementById('cancel-new-status').addEventListener('click', () => {
      document.getElementById('new-status-modal').classList.add('hidden')
      document.getElementById('new-status-name').value = ''
    })

    // New tech stack modal
    document.getElementById('save-new-tech-stack').addEventListener('click', () => {
      const name = document.getElementById('new-tech-stack-name').value.trim()
      if (name) {
        this.createNewTechStack(name)
      }
    })

    document.getElementById('cancel-new-tech-stack').addEventListener('click', () => {
      document.getElementById('new-tech-stack-modal').classList.add('hidden')
      document.getElementById('new-tech-stack-name').value = ''
    })

    // Close modals on outside click
    document.getElementById('new-status-modal').addEventListener('click', (e) => {
      if (e.target.id === 'new-status-modal') {
        document.getElementById('new-status-modal').classList.add('hidden')
      }
    })

    document.getElementById('new-tech-stack-modal').addEventListener('click', (e) => {
      if (e.target.id === 'new-tech-stack-modal') {
        document.getElementById('new-tech-stack-modal').classList.add('hidden')
      }
    })
  }

  createNewStatus(name) {
    // Get CSRF token
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') ||
                     document.querySelector('[name="csrf-token"]')?.content

    if (!csrfToken) {
      alert('CSRF token not found. Please refresh the page and try again.')
      return
    }

    fetch('/job_applications/create_status', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
        'Accept': 'application/json'
      },
      body: JSON.stringify({ name: name })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.json()
    })
    .then(data => {
      if (data.id) {
        // Add to all status selects
        const statusSelects = document.querySelectorAll('.status-select')
        statusSelects.forEach(select => {
          // Remove the "+ Add New Status" option temporarily
          const addNewOption = select.querySelector('option[value="__new__"]')
          if (addNewOption) {
            addNewOption.remove()
          }
          
          // Add the new status option
          const option = new Option(data.name, data.id)
          select.add(option)
          
          // Re-add the "+ Add New Status" option at the bottom
          const newAddNewOption = new Option('+ Add New Status', '__new__')
          select.add(newAddNewOption)
        })
        
        document.getElementById('new-status-modal').classList.add('hidden')
        document.getElementById('new-status-name').value = ''
        
        // Set the new status as selected in the current row
        const currentRow = document.querySelector('.status-select:not(.hidden)').closest('tr')
        if (currentRow) {
          currentRow.querySelector('.status-select').value = data.id
        }
      } else {
        alert('Error creating status: ' + (data.error || 'Unknown error'))
      }
    })
    .catch(error => {
      console.error('Error:', error)
      alert('Error creating status: ' + error.message)
    })
  }

  createNewTechStack(name) {
    // Get CSRF token
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') ||
                     document.querySelector('[name="csrf-token"]')?.content

    if (!csrfToken) {
      alert('CSRF token not found. Please refresh the page and try again.')
      return
    }

    fetch('/job_applications/create_tech_stack', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
        'Accept': 'application/json'
      },
      body: JSON.stringify({ name: name })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.json()
    })
    .then(data => {
      if (data.id) {
        // Add to all tech stack selects
        const techStackSelects = document.querySelectorAll('.tech-stacks-select')
        techStackSelects.forEach(select => {
          // Remove the "+ Add New Tech Stack" option temporarily
          const addNewOption = select.querySelector('option[value="__new__"]')
          if (addNewOption) {
            addNewOption.remove()
          }
          
          // Add the new tech stack option
          const option = new Option(data.name, data.name)
          select.add(option)
          
          // Re-add the "+ Add New Tech Stack" option at the bottom
          const newAddNewOption = new Option('+ Add New Tech Stack', '__new__')
          select.add(newAddNewOption)
        })
        
        document.getElementById('new-tech-stack-modal').classList.add('hidden')
        document.getElementById('new-tech-stack-name').value = ''
        
        // Set the new tech stack as selected in the current row
        const currentRow = document.querySelector('.tech-stacks-select:not(.hidden)').closest('tr')
        if (currentRow) {
          const select = currentRow.querySelector('.tech-stacks-select')
          select.value = data.name
        }
      } else {
        alert('Error creating tech stack: ' + (data.error || 'Unknown error'))
      }
    })
    .catch(error => {
      console.error('Error:', error)
      alert('Error creating tech stack: ' + error.message)
    })
  }
} 